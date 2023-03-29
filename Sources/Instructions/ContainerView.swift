//
//  ContainerView.swift
//  Instructions
//
//  Created by Jake Heiser on 9/21/21.
//

import SwiftUI

public struct InstructionsContainerView<Content: View>: View {
    @State private var popoverSize: CGSize = .zero
    @StateObject private var instructions = Instructions()
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .environmentObject(instructions)
            .overlayPreferenceValue(InstructionsTagPreferenceKey.self) { all in
                InstructionsOverlay(instructionsState: instructions.statePublisher, instructions: instructions, allRecordedItems: all, popoverSize: popoverSize)
            }
            .onPreferenceChange(CalloutPreferenceKey.self) {
                popoverSize = $0
            }
    }
}

public struct SkipButton: View {
    @EnvironmentObject private var instructions: Instructions
    
    public var body: some View {
        Button(action: {
            Task {
                await quit()
            }
        }) {
            Text("Skip")
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.white)
                        .shadow(radius: 1)
                )
        }
        .padding(.trailing, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    private func quit() async {
        await instructions.stop()
    }
}

private struct InstructionsOverlay: View {
    @ObservedObject var instructionsState: InstructionsStatePublisher
    
    let instructions: Instructions
    let allRecordedItems: InstructionsTagPreferenceKey.Value
    let popoverSize: CGSize
    
    var body: some View {
        ZStack {
            if instructionsState.state == .transition {
                instructions.delegate.overlay(instructions: instructions)
                    .edgesIgnoringSafeArea(.all)
                
                if let current = instructions.current, let details = allRecordedItems[current] {
                    details.callout.createView(onTap: {})
                        .opacity(0)
                }
            } else if instructionsState.state == .active {
                if let current = instructions.current,  let tagInfo = allRecordedItems[current] {
                    ActiveInstructionsOverlay(tagInfo: tagInfo, instructions: instructions, popoverSize: popoverSize)
                }
            }
            
            if instructionsState.state != .hidden {
                instructions.delegate.accessoryView(instructions: instructions)
                    .environmentObject(instructions)
            }
        }
    }
}

private struct ActiveInstructionsOverlay: View {
    let tagInfo: InstructionsTagInfo
    let instructions: Instructions
    let popoverSize: CGSize
    
    var body: some View {
        GeometryReader { proxy in
            cutoutTint(for: proxy[tagInfo.anchor], screenSize: proxy.size)
                .onTapGesture {
                    Task {
                        do {
                            try await instructions.delegate.onBackgroundTap(instructions: instructions)
                        } catch {
                            print("\n\(error.localizedDescription)\n")
                        }
                    }
                }
            
            touchModeView(for: proxy[tagInfo.anchor], mode: instructions.delegate.cutoutTouchMode(instructions: instructions))
            
            tagInfo.callout.createView(onTap: {
                Task {
                    do {
                        try await instructions.delegate.onCalloutTap(instructions: instructions)
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
                instructions.delegate.overlay(instructions: instructions)
                    .frame(width: cutoutFrame.minX, height: screenSize.height)
            }
            
            if cutoutFrame.maxX < screenSize.width {
                instructions.delegate.overlay(instructions: instructions)
                    .frame(width: screenSize.width - cutoutFrame.maxX, height: screenSize.height)
                    .offset(x: cutoutFrame.maxX)
            }
            
            if cutoutFrame.minY > 0 {
                instructions.delegate.overlay(instructions: instructions)
                    .frame(width: cutoutFrame.width, height: cutoutFrame.minY)
                    .offset(x: cutoutFrame.minX)
            }
            
            if cutoutFrame.maxY < screenSize.height {
                instructions.delegate.overlay(instructions: instructions)
                    .frame(width: cutoutFrame.width, height: screenSize.height - cutoutFrame.maxY)
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
                .frame(width: cutout.width, height: cutout.height)
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
                .frame(width: cutout.width, height: cutout.height)
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

public struct GuidableView<Content: View, Tags: InstructionsTags>: View {
    @EnvironmentObject private var instructions: Instructions
    
    let isActive: Bool
    let delegate: InstructionsDelegate?
    let startDelay: Double
    let content: Content
    
    init(isActive: Bool, tags: Tags.Type, delegate: InstructionsDelegate?, startDelay: Double = 0.5, @ViewBuilder content: () -> Content) {
        self.isActive = isActive
        self.delegate = delegate
        self.startDelay = startDelay
        self.content = content()
    }
    
    public var body: some View {
        content
            .task {
                if isActive {
                    do {
                        try await Task.sleep(nanoseconds: UInt64(startDelay * 1000000000))
                        
                        try await instructions.start(tags: Tags.self, delegate: delegate)
                    } catch {
                        print("\n\(error.localizedDescription)\n")
                    }
                }
            }
            .onDisappear {
                Task {
                    await instructions.stop()
                }
            }
            .onChange(of: isActive) { active in
                if active {
                    Task {
                        do {
                            try await instructions.start(tags: Tags.self, delegate: delegate)
                        } catch {
                            print("\n\(error.localizedDescription)\n")
                        }
                    }
                }
            }
    }
}

struct InstructionsTagInfo {
    let anchor: Anchor<CGRect>
    let callout: Callout
}

struct InstructionsTagPreferenceKey: PreferenceKey {
    typealias Value = [String: InstructionsTagInfo]
    
    static var defaultValue: Value = [:]
    
    static func reduce(value acc: inout Value, nextValue: () -> Value) {
        let newValue = nextValue()
        
        for (key, value) in newValue {
            acc[key] = value
        }
    }
}
