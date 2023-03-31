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
        case fullScreenCover
        case navigationLink
        
        func makeCallout() -> Callout {
            switch self {
            case .sheet:
                return .text("This is a sheet", edge: .bottom)
            case .fullScreenCover:
                return .okText("This is a fullScreenCover link", edge: .bottom)
            case .navigationLink:
                return .bubble(edge: .bottom) {
                    Text("This is a navigation link")
                }
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
    
    var basicDemoFullScreenCover: some View {
        EmptyView().fullScreenCover(isPresented: $isActive) {
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
                
                Button(action: {
                    isActive = true
                    
                    sceneDelegate.setupWindow {
                        basicDemoFullScreenCover
                    }
                }) {
                    Text("Basic Demo")
                }
                .instructionsTag(Tags.fullScreenCover)
                
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
