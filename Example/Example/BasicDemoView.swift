//
//  BasicDemoView.swift
//  Example
//
//  Created by Jake Heiser on 9/22/21.
//

import Instructions
import SwiftUI

struct BasicDemoView: View {
    @Binding var isActive: Bool
    @EnvironmentObject private var sceneDelegate: SceneDelegate
    
    enum Tags: InstructionsTags {
        case profilePicture
        case name
        case username
        
        func makeCallout() -> Callout {
            switch self {
            case .profilePicture:
                return .text("Nice profile picture", edge: .bottom)
            case .name:
                return .okText("Here is your name")
            case .username:
                return .bubble {
                    Text("Your current username")
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100)
                    .instructionsTag(Tags.profilePicture)
                
                Text("John Smith")
                    .instructionsTag(Tags.name)
                
                Spacer()
                
                HStack(spacing: 10) {
                    ProfileDetailView(text: "34 posts")
                    
                    ProfileDetailView(text: "@jsmith")
                        .instructionsTag(Tags.username)
                    
                    ProfileDetailView(text: "29 karma")
                }
            }
            .padding()
            .instructions(isActive: true, tags: Tags.self)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isActive = false
                    }) {
                        Text("Close")
                    }
                }
            }
            .navigationTitle("Basic Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct BasicDemo_Previews: PreviewProvider {
    static var previews: some View {
        BasicDemoView(isActive: .constant(true))
    }
}
