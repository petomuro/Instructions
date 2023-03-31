//
//  Protocols.swift
//  
//
//  Created by Peter Murin on 31/03/2023.
//

public protocol InstructionsTags: CaseIterable {
    func makeCallout() -> Callout
}

extension InstructionsTags {
    func key() -> String {
        String(reflecting: Self.self) + "." + String(describing: self)
    }
}
