//
//  BasicDemo2.swift
//  Example
//
//  Created by Peter Murin on 29/03/2023.
//

import Instructions
import SwiftUI

struct BasicDemo2: View {
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
        .navigationTitle("Basic Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BasicDemo2_Previews: PreviewProvider {
    static var previews: some View {
        BasicDemo2()
    }
}
