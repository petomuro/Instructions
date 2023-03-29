//
//  ManualDemo.swift
//  Example
//
//  Created by Jake Heiser on 9/22/21.
//

import Instructions
import SwiftUI

struct ManualDemo: View {
    enum Tags: InstructionsTags {
        case choice
        case left
        case right
        case final
        
        func makeCallout() -> Callout {
            switch self {
            case .choice:
                return .text("Choose left or right")
            case .left:
                return .okText("You chose left", edge: .trailing)
            case .right:
                return .okText("You chose right", edge: .leading)
            case .final:
                return .okText("But both end here")
            }
        }
    }
    
    @EnvironmentObject var instructions: Instructions
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    do {
                        try await startTapped()
                    } catch {
                        print("\n\(error.localizedDescription)\n")
                    }
                }
            }) {
                Text("Start")
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.blue)
                    )
            }
            
            HStack {
                Button(action: {
                    Task {
                        do {
                            try await instructions.jump(to: Tags.left)
                        } catch {
                            print("\n\(error.localizedDescription)\n")
                        }
                    }
                }) {
                    Text("Go left")
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        do {
                            try await instructions.jump(to: Tags.right)
                        } catch {
                            print("\n\(error.localizedDescription)\n")
                        }
                    }
                }) {
                    Text("Go Right")
                }
            }
            .padding()
            .instructionsTag(Tags.choice)
            
            HStack {
                Text("Left")
                    .instructionsTag(Tags.left)
                
                Spacer()
                
                Text("Right")
                    .instructionsTag(Tags.right)
            }
            .padding()
            
            Text("End here")
                .instructionsTag(Tags.final)
        }
    }
    
    func startTapped() async throws {
        try await instructions.start(tags: Tags.self, delegate: self)
    }
}

extension ManualDemo: InstructionsDelegate {
    func cutoutTouchMode(instructions: Instructions) -> CutoutTouchMode {
        switch instructions.matchCurrent(Tags.self) {
        case .choice:
            return .passthrough
        default:
            return .custom {
                Task {
                    do {
                        try await handleTap(tag: instructions.matchCurrent(Tags.self))
                    } catch {
                        print("\n\(error.localizedDescription)\n")
                    }
                }
            }
        }
    }
    
    func onBackgroundTap(instructions: Instructions) async throws {
        try await handleTap(tag: instructions.matchCurrent(Tags.self))
    }
    
    func onCalloutTap(instructions: Instructions) async throws {
        try await handleTap(tag: instructions.matchCurrent(Tags.self))
    }
    
    private func handleTap(tag: Tags?) async throws {
        switch instructions.matchCurrent(Tags.self) {
        case .left, .right:
            try await instructions.jump(to: Tags.final)
        case .final:
            try await instructions.advance()
        default:
            break
        }
    }
}
