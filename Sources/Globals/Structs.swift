//
//  Structs.swift
//  
//
//  Created by Peter Murin on 31/03/2023.
//

import SwiftUI

struct CalloutPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct InstructionsTagInfo {
    let anchor: Anchor<CGRect>
    let callout: Callout
}

struct InstructionsTagPreferenceKey: PreferenceKey {
    static var defaultValue: [String: InstructionsTagInfo] = [:]
    
    static func reduce(value acc: inout [String: InstructionsTagInfo], nextValue: () -> [String: InstructionsTagInfo]) {
        let newValue = nextValue()
        
        for (key, value) in newValue {
            acc[key] = value
        }
    }
}
