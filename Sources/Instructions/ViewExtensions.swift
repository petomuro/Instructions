//
//  ViewExtensions.swift
//  Instructions
//
//  Created by Jake Heiser on 9/22/21.
//

import SwiftUI

extension View {
    public func instructions<Tags: InstructionsTags>(isActive: Bool, tags: Tags.Type, delegate: InstructionsDelegate? = nil) -> some View {
        GuidableView(isActive: isActive, tags: tags, delegate: delegate) {
            self
        }
    }
    
    public func instructionsTag<T: InstructionsTags>(_ tag: T) -> some View {
        anchorPreference(key: InstructionsTagPreferenceKey.self, value: .bounds, transform: { anchor in
            return [tag.key(): InstructionsTagInfo(anchor: anchor, callout: tag.makeCallout())]
        })
    }
    
    public func instructionsExtensionTag<T: InstructionsTags>(_ tag: T, edge: Edge, size: CGFloat = 100) -> some View {
        let width: CGFloat? = (edge == .leading || edge == .trailing) ? size : nil
        let height: CGFloat? = (edge == .top || edge == .bottom) ? size : nil
        
        let alignment: Alignment
        
        switch edge {
        case .top:
            alignment = .top
        case .leading:
            alignment = .leading
        case .trailing:
            alignment = .trailing
        case .bottom:
            alignment = .bottom
        }
        
        let overlayView = Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(width: width, height: height)
            .instructionsTag(tag)
            .padding(Edge.Set(edge), -size)
        
        return overlay(overlayView, alignment: alignment)
    }
    
    public func stopInstructions(_ instructions: Instructions, onLink navigationLink: Bool) -> some View {
        onChange(of: navigationLink) { shown in
            if shown {
                Task {
                    await instructions.stop()
                }
            }
        }
    }
    
    public func stopInstructions<V: Hashable>(_ instructions: Instructions, onTag navigationTag: V, selection: V) -> some View {
        onChange(of: selection) { value in
            if navigationTag == value {
                Task {
                    await instructions.stop()
                }
            }
        }
    }
}

