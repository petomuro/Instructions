//
//  ContentView.swift
//  InstructionsTest
//
//  Created by Jake Heiser on 9/15/21.
//

import SwiftUI

struct InstructionsDemoList: View {
    private enum ActiveSheet {
        case basicDemo
        case barDemo
        case customDemo
        case manualDemo
    }
    
    @State private var activeSheet: ActiveSheet?
    @State private var isActive: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BasicDemo()) {
                    Text("Basic")
                }
                
                NavigationLink(destination: BarDemo()) {
                    Text("Bars")
                }
                
                NavigationLink(destination: CustomDemo()) {
                    Text("Custom")
                }
                
                NavigationLink(destination: ManualDemo()) {
                    Text("Manual flow control")
                }
                
                Button(action: {
                    activeSheet = .basicDemo
                    isActive = true
                }) {
                    Text("Basic")
                }
                
                Button(action: {
                    activeSheet = .barDemo
                    isActive = true
                }) {
                    Text("Bars")
                }
                
                Button(action: {
                    activeSheet = .customDemo
                    isActive = true
                }) {
                    Text("Custom")
                }
                
                Button(action: {
                    activeSheet = .manualDemo
                    isActive = true
                }) {
                    Text("Manual flow control")
                }
            }
            .sheet(isPresented: $isActive) {
                NavigationView {
                    Group {
                        switch activeSheet {
                        case .basicDemo:
                            BasicDemo()
                                .navigationTitle("Basic Demo")
                        case .barDemo:
                            BarDemo()
                                .navigationTitle("Bar Demo")
                        case .customDemo:
                            CustomDemo()
                                .navigationTitle("Custom Demo")
                        case .manualDemo:
                            ManualDemo()
                                .navigationTitle("Manual Demo")
                        default:
                            EmptyView()
                        }
                    }
                    .navigationViewStyle(.stack)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                activeSheet = nil
                                isActive = false
                            }) {
                                Text("Back")
                            }
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
            .navigationTitle("Instructions Demos")
        }
    }
}
