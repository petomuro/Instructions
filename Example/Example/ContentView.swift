//
//  ContentView.swift
//  InstructionsTest
//
//  Created by Jake Heiser on 9/15/21.
//

import Instructions
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var sceneDelegate: SceneDelegate
    @State private var isActive: Bool = false
    
    enum Tags: InstructionsTags {
        case sheet
        case navigationLink
        
        func makeCallout() -> Callout {
            switch self {
            case .sheet:
                return .text("This is a sheet", edge: .bottom)
            case .navigationLink:
                return .okText("This is a navigation link", edge: .bottom)
            }
        }
    }
    
    var basicDemoSheet: some View {
        EmptyView().sheet(isPresented: $isActive) {
            InstructionsContentView {
                BasicDemoView(isActive: $isActive)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    isActive = true
                    
                    sceneDelegate.setupWindow {
                        basicDemoSheet
                    }
                }) {
                    Text("Basic Demo")
                }
                .instructionsTag(Tags.sheet)
                
                NavigationLink(destination: BasicDemo2View()) {
                    Text("Basic Demo")
                }
                .instructionsTag(Tags.navigationLink)
            }
            .instructions(isActive: true, tags: Tags.self)
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
