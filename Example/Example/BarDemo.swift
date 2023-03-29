//
//  BarDemo.swift
//  Example
//
//  Created by Jake Heiser on 9/22/21.
//

import Instructions
import SwiftUI

struct BarDemo: View {
    enum Tags: InstructionsTags {
        case navBar
        case toolbar
        
        func makeCallout() -> Callout {
            switch self {
            case .navBar:
                return .text("This is the navigation bar", edge: .bottom)
            case .toolbar:
                return .text("And here is the toolbar")
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            
            Text("John Smith")
            
            Spacer()
            
            HStack(spacing: 10) {
                ProfileDetail(text: "34 posts")
                
                ProfileDetail(text: "@jsmith")
                
                ProfileDetail(text: "29 karma")
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {}) {
                    Text("Toolbar")
                }
            }
        }
        .instructionsExtensionTag(Tags.navBar, edge: .top)
        .instructionsExtensionTag(Tags.toolbar, edge: .bottom)
        .instructions(isActive: true, tags: Tags.self)
    }
}
