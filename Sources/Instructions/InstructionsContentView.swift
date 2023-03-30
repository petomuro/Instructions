//
//  InstructionsContentView.swift
//  Instructions
//
//  Created by Jake Heiser on 9/21/21.
//

import SwiftUI

private enum CutoutTouchMode {
    case passthrough
    case advance
    case custom(() -> Void)
}

struct InstructionsTagInfo {
    let anchor: Anchor<CGRect>
    let callout: Callout
}

private struct ActiveInstructionsOverlay: View {
    @EnvironmentObject private var instructions: Instructions
    
    let popoverSize: CGSize
    let tagInfo: InstructionsTagInfo
    
    var body: some View {
        GeometryReader { proxy in
            cutoutTint(for: proxy[tagInfo.anchor], screenSize: proxy.size)
                .onTapGesture {
                    Task {
                        do {
                            try await instructions.advance()
                        } catch {
                            print("\n\(error.localizedDescription)\n")
                        }
                    }
                }
            
            touchModeView(for: proxy[tagInfo.anchor], mode: .advance)
            
            tagInfo.callout.createView(onTap: {
                Task {
                    do {
                        try await instructions.advance()
                    } catch {
                        print("\n\(error.localizedDescription)\n")
                    }
                }
            })
            .offset(x: cutoutOffsetX(cutout: proxy[tagInfo.anchor]), y: cutoutOffsetY(cutout: proxy[tagInfo.anchor]))
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func cutoutTint(for cutoutFrame: CGRect, screenSize: CGSize) -> some View {
        ZStack(alignment: .topLeading) {
            if cutoutFrame.minX > 0 {
                OverlayView()
                    .frame(maxWidth: cutoutFrame.minX, maxHeight: screenSize.height)
            }
            
            if cutoutFrame.maxX < screenSize.width {
                OverlayView()
                    .frame(maxWidth: screenSize.width - cutoutFrame.maxX, maxHeight: screenSize.height)
                    .offset(x: cutoutFrame.maxX)
            }
            
            if cutoutFrame.minY > 0 {
                OverlayView()
                    .frame(maxWidth: cutoutFrame.width, maxHeight: cutoutFrame.minY)
                    .offset(x: cutoutFrame.minX)
            }
            
            if cutoutFrame.maxY < screenSize.height {
                OverlayView()
                    .frame(maxWidth: cutoutFrame.width, maxHeight: screenSize.height - cutoutFrame.maxY)
                    .offset(x: cutoutFrame.minX, y: cutoutFrame.maxY)
            }
        }
    }
    
    @ViewBuilder
    private func touchModeView(for cutout: CGRect, mode: CutoutTouchMode) -> some View {
        switch mode {
        case .passthrough:
            EmptyView()
        case .advance:
            Color.black
                .opacity(0.05)
                .frame(maxWidth: cutout.width, maxHeight: cutout.height)
                .offset(x: cutout.minX, y: cutout.minY)
                .onTapGesture {
                    Task {
                        do {
                            try await instructions.advance()
                        } catch {
                            print("\n\(error.localizedDescription)\n")
                        }
                    }
                }
        case .custom(let action):
            Color.black
                .opacity(0.05)
                .frame(maxWidth: cutout.width, maxHeight: cutout.height)
                .offset(x: cutout.minX, y: cutout.minY)
                .onTapGesture {
                    action()
                }
        }
    }
    
    private func cutoutOffsetX(cutout: CGRect) -> CGFloat {
        switch tagInfo.callout.edge {
        case .top, .bottom:
            return cutout.midX - popoverSize.width / 2
        case .leading:
            return cutout.minX - popoverSize.width
        case .trailing:
            return cutout.maxX
        }
    }
    
    private func cutoutOffsetY(cutout: CGRect) -> CGFloat {
        switch tagInfo.callout.edge {
        case .leading, .trailing:
            return cutout.midY - popoverSize.height / 2
        case .top:
            return cutout.minY - popoverSize.height
        case .bottom:
            return cutout.maxY
        }
    }
}

private struct InstructionsOverlay: View {
    @EnvironmentObject private var instructions: Instructions
    @State private var popoverSize: CGSize = .zero
    
    let allRecordedItems: InstructionsTagPreferenceKey.Value
    
    var body: some View {
        ZStack {
            if instructions.state == .transition {
                OverlayView()
                
                if let current = instructions.current, let details = allRecordedItems[current] {
                    details.callout.createView(onTap: {})
                        .opacity(0)
                }
            } else if instructions.state == .active {
                if let current = instructions.current,  let tagInfo = allRecordedItems[current] {
                    ActiveInstructionsOverlay(popoverSize: popoverSize, tagInfo: tagInfo)
                        .onPreferenceChange(CalloutPreferenceKey.self) {
                            popoverSize = $0
                        }
                }
            }
            
            if instructions.state != .hidden {
                SkipButtonView()
            }
        }
    }
}

public struct InstructionsContentView<Content: View>: View {
    @StateObject private var instructions = Instructions()
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environmentObject(instructions)
            .overlayPreferenceValue(InstructionsTagPreferenceKey.self) { all in
                InstructionsOverlay(allRecordedItems: all)
                    .environmentObject(instructions)
            }
    }
}
