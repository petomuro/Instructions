//
//  InstructionsContentView.swift
//
//
//  Created by Jake Heiser on 9/21/21.
//

import SwiftUI

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
