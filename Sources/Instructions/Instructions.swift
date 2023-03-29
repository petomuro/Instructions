//
//  Instructions.swift
//  Instructions
//
//  Created by Jake Heiser on 9/21/21.
//

import SwiftUI

public protocol InstructionsDelegate {
    func accessoryView(instructions: Instructions) -> AnyView?
    func overlay(instructions: Instructions) -> AnyView?
    func cutoutTouchMode(instructions: Instructions) -> CutoutTouchMode
    func onBackgroundTap(instructions: Instructions) async throws
    func onCalloutTap(instructions: Instructions) async throws
}

extension InstructionsDelegate {
    public func accessoryView(instructions: Instructions) -> AnyView? {
        AnyView(SkipButton())
    }
    
    public func overlay(instructions: Instructions) -> AnyView? {
        AnyView(Color(white: 0.8, opacity: 0.5))
    }
    
    public func cutoutTouchMode(instructions: Instructions) -> CutoutTouchMode {
        .advance
    }
    
    public func onBackgroundTap(instructions: Instructions) async throws {
        try await instructions.advance()
    }
    
    public func onCalloutTap(instructions: Instructions) async throws {
        try await instructions.advance()
    }
}

struct DefaultInstructionsDelegate: InstructionsDelegate {}

public final class Instructions: ObservableObject {
    let statePublisher = InstructionsStatePublisher()
    public private(set) var current: String? = nil
    
    private var currentPlan: [String]?
    
    var delegate: InstructionsDelegate = DefaultInstructionsDelegate()
    
    public func start<Tags: InstructionsTags>(tags: Tags.Type, delegate: InstructionsDelegate?) async throws {
        let plan = tags.allCases.map {
            $0.key()
        }
        
        currentPlan = plan
        
        self.delegate = delegate ?? DefaultInstructionsDelegate()
        
        if plan.count > 0 {
            try await moveTo(item: plan[0])
            
            current = plan[0]
        }
    }
    
    public func matchCurrent<T: InstructionsTags>(_ tags: T.Type) -> T? {
        T.allCases.first(where: {
            $0.key() == current
        })
    }
    
    public func advance() async throws {
        guard let current = current, let currentPlan = currentPlan else {
            return
        }
        
        guard let index = currentPlan.firstIndex(of: current) else {
            return
        }
        
        guard index + 1 < currentPlan.count else {
            await stop()
            
            return
        }
        
        try await moveTo(item: currentPlan[index + 1])
    }
    
    public func jump<T: InstructionsTags>(to tag: T) async throws {
        guard let currentPlan = currentPlan, let index = currentPlan.firstIndex(of: tag.key()) else {
            return
        }
        
        try await moveTo(item: currentPlan[index])
    }
    
    public func stop() async {
        await stopImpl()
    }
    
    @MainActor
    private func moveTo(item: String) async throws {
        if statePublisher.state == .active {
            withAnimation {
                statePublisher.state = .transition
            }
            
            try await Task.sleep(nanoseconds: 500000000)
            
            withAnimation {
                current = item
                statePublisher.state = .transition
                statePublisher.state = .active
            }
        } else {
            withAnimation {
                current = item
                statePublisher.state = .active
            }
        }
    }
    
    @MainActor
    private func stopImpl() {
        withAnimation {
            statePublisher.state = .hidden
            currentPlan = nil
            current = nil
        }
    }
}

class InstructionsStatePublisher: ObservableObject {
    @Published var state: State = .hidden
    
    enum State {
        case hidden
        case transition
        case active
    }
}

public protocol InstructionsTags: CaseIterable {
    func makeCallout() -> Callout
}

extension InstructionsTags {
    func key() -> String {
        String(reflecting: Self.self) + "." + String(describing: self)
    }
}
