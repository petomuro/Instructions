//
//  GuidableView.swift
//  
//
//  Created by Peter Murin on 29/03/2023.
//

import SwiftUI

struct GuidableView<Content: View, Tags: InstructionsTags>: View {
    @EnvironmentObject private var instructions: Instructions
    @ViewBuilder var content: Content
    
    let isActive: Bool
    let tags: Tags.Type
    let startDelay: Double = 0.5
    
    var body: some View {
        content
            .task {
                if isActive {
                    do {
                        try await Task.sleep(nanoseconds: UInt64(startDelay * 1000000000))
                        try await instructions.start(tags: Tags.self)
                    } catch {
                        print("\n\(error.localizedDescription)\n")
                    }
                }
            }
            .onDisappear {
                Task {
                    await instructions.stop()
                }
            }
            .onChange(of: isActive) { active in
                if active {
                    Task {
                        do {
                            try await instructions.start(tags: Tags.self)
                        } catch {
                            print("\n\(error.localizedDescription)\n")
                        }
                    }
                }
            }
    }
}

struct GuidableView_Previews: PreviewProvider {
    enum Tags: InstructionsTags {
        case profilePicture
        case name
        
        func makeCallout() -> Callout {
            switch self {
            case .profilePicture:
                return .text("Nice profile picture", edge: .bottom)
            case .name:
                return .okText("Here is your name")
            }
        }
    }
    
    static var previews: some View {
        InstructionsContainerView {
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
                }
                .instructions(isActive: true, tags: Tags.self)
            }
        }
    }
}
