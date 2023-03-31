//
//  Instructions.swift
//
//
//  Created by Jake Heiser on 9/21/21.
//

import SwiftUI

public class Instructions: ObservableObject {
    @Published var state: InstructionsState = .hidden
    
    private var currentPlan: [String]?
    private(set) var current: String? = nil
    
    enum InstructionsState {
        case hidden
        case transition
        case active
    }
    
    @MainActor
    private func moveTo(item: String) async throws {
        if state == .active {
            withAnimation {
                state = .transition
            }
            
            try await Task.sleep(nanoseconds: 500000000)
            
            withAnimation {
                current = item
                state = .transition
                state = .active
            }
        } else {
            withAnimation {
                current = item
                state = .active
            }
        }
    }
    
    @MainActor
    private func stopImpl() {
        withAnimation {
            state = .hidden
            currentPlan = nil
            current = nil
        }
    }
    
    func stop() async {
        await stopImpl()
    }
    
    func advance() async throws {
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
    
    func jump<T: InstructionsTags>(to tag: T) async throws {
        guard let currentPlan = currentPlan, let index = currentPlan.firstIndex(of: tag.key()) else {
            return
        }
        
        try await moveTo(item: currentPlan[index])
    }
    
    func matchCurrent<T: InstructionsTags>(_ tags: T.Type) -> T? {
        T.allCases.first(where: {
            $0.key() == current
        })
    }
    
    func start<Tags: InstructionsTags>(tags: Tags.Type) async throws {
        let plan = tags.allCases.map {
            $0.key()
        }
        
        currentPlan = plan
        
        if plan.count > 0 {
            try await moveTo(item: plan.first ?? "")
            
            current = plan.first ?? ""
        }
    }
}
