//
//  BasicDemo2View.swift
//  Example
//
//  Created by Peter Murin on 29/03/2023.
//

import Instructions
import SwiftUI

struct BasicDemo2View: View {
    @EnvironmentObject private var sceneDelegate: SceneDelegate
    
    enum Tags: InstructionsTags {
            case profilePicture
            case name
            case username
            
            func makeCallout() -> Callout {
                switch self {
                case .profilePicture:
                    return .okText("Nice profile picture", edge: .bottom)
                case .name:
                    return .bubble {
                        Text("Here is your name")
                    }
                case .username:
                    return .custom(edge: .top) { _ in
                        Text("Your current username")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.green, lineWidth: 1)
                            )
                            .padding(.bottom)
                    }
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
                ProfileDetailView(text: "34 posts")
                
                ProfileDetailView(text: "@jsmith")
                    .instructionsTag(Tags.username)
                
                ProfileDetailView(text: "29 karma")
            }
        }
        .padding()
        .instructions(isActive: true, tags: Tags.self)
        .navigationTitle("Basic Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BasicDemo2View_Previews: PreviewProvider {
    static var previews: some View {
        BasicDemo2View()
    }
}
