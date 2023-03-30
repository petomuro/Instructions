//
//  BasicDemo.swift
//  Example
//
//  Created by Jake Heiser on 9/22/21.
//

import Instructions
import SwiftUI

struct BasicDemo: View {
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
                return .text("Your current username")
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
                    ProfileDetail(text: "34 posts")
                    
                    ProfileDetail(text: "@jsmith")
                        .instructionsTag(Tags.username)
                    
                    ProfileDetail(text: "29 karma")
                }
            }
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
        BasicDemo(isActive: .constant(true))
    }
}
