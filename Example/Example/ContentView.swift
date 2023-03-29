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
    
    var basicDemoSheet: AnyView {
        AnyView(EmptyView().sheet(isPresented: $isActive) {
            InstructionsContainerView {
                BasicDemo(isActive: $isActive)
            }
        })
    }
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    isActive = true
                    
                    sceneDelegate.setupWindow(view: basicDemoSheet)
                }) {
                    Text("Basic Demo")
                }
                
                NavigationLink(destination: BasicDemo2()) {
                    Text("Basic Demo")
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
