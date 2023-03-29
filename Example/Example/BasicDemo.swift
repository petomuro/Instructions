//
//  BasicDemo.swift
//  Example
//
//  Created by Jake Heiser on 9/22/21.
//

import Instructions
import SwiftUI

struct MyView: View {
    enum Tags: InstructionsTags {
        case hello
        
        func makeCallout() -> Callout {
            .text("This is a message saying hello")
        }
    }
    
    var body: some View {
        VStack {
            Text("Hello world")
                .instructionsTag(Tags.hello)
        }
        .instructions(isActive: true, tags: Tags.self)
    }
}

struct BasicDemo: View {
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
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 100)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .instructions(isActive: true, tags: Tags.self)
    }
}

struct ProfileDetail: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(.horizontal)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(.green)
            )
    }
}

