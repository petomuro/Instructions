//
//  InstructionsOverlay.swift
//  
//
//  Created by Peter Murin on 31/03/2023.
//

import SwiftUI

struct InstructionsOverlay: View {
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
                if let current = instructions.current, let tagInfo = allRecordedItems[current] {
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

struct InstructionsOverlay_Previews: PreviewProvider {
    @StateObject static var instructions = Instructions()
    
    static var previews: some View {
        EmptyView()
            .overlayPreferenceValue(InstructionsTagPreferenceKey.self) { all in
                InstructionsOverlay(allRecordedItems: all)
                    .environmentObject(instructions)
            }
    }
}
