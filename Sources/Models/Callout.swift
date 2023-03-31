//
//  Callout.swift
//
//
//  Created by Jake Heiser on 9/21/21.
//

import SwiftUI

public struct Callout {
    let body: (_ onTap: @escaping () -> Void) -> AnyView
    let edge: Edge
    
    func createView(onTap: @escaping () -> Void) -> some View {
        body(onTap)
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: CalloutPreferenceKey.self, value: proxy.size)
                }
            )
    }
    
    public static func text(_ text: String, edge: Edge = .top) -> Self {
        .bubble(edge: edge) {
            Text(text)
        }
    }
    
    public static func okText(_ text: String, edge: Edge = .top) -> Self {
        .bubble(edge: edge) {
            HStack {
                Text(text)
                    .padding(.trailing, 5)
                
                Color.black
                    .frame(maxWidth: 1)
                
                Text("Ok")
                    .padding(.leading, 5)
                
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    public static func bubble<V: View>(edge: Edge = .top, @ViewBuilder content: () -> V) -> Self {
        let inside = content()
        let bodyBlock: (@escaping () -> Void) -> AnyView = { onTap in
            AnyView(Button(action: {
                onTap()
            }) {
                inside
                    .padding(5)
            }
                .padding(.horizontal)
                .buttonStyle(CalloutButtonStyle(edge: edge)))
        }
        
        return .init(body: bodyBlock, edge: edge)
    }
    
    public static func custom<V: View>(edge: Edge = .top, @ViewBuilder content: @escaping (_ onTap: @escaping () -> Void) -> V) -> Self {
        return .init(body: {
            onTap in AnyView(content(onTap))
        }, edge: edge)
    }
}
