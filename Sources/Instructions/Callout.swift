//
//  Callout.swift
//  Instructions
//
//  Created by Jake Heiser on 9/21/21.
//

import SwiftUI

private struct CalloutBubble: Shape {
    let edge: Edge
    
    fileprivate func path(in rect: CGRect) -> Path {
        let pointerWidth: CGFloat = 10
        let pointerHeight: CGFloat = 10
        
        var path = Path()
        let points: [CGPoint]
        let frame: CGRect
        
        switch edge {
        case .bottom:
            points = [
                .init(x: rect.width / 2 - pointerWidth / 2, y: pointerHeight),
                .init(x: rect.width / 2 + pointerWidth / 2, y: pointerHeight),
                .init(x: rect.width / 2, y: 0)
            ]
            
            frame = .init(x: 0, y: pointerHeight, width: rect.width, height: rect.height - pointerHeight)
        case .top:
            points = [
                .init(x: rect.width / 2 - pointerWidth / 2, y: rect.height - pointerHeight),
                .init(x: rect.width / 2 + pointerWidth / 2, y: rect.height - pointerHeight),
                .init(x: rect.width / 2, y: rect.height)
            ]
            
            frame = .init(x: 0, y: 0, width: rect.width, height: rect.height - pointerHeight)
        case .leading:
            points = [
                .init(x: rect.width - pointerHeight, y: rect.height / 2 - pointerWidth / 2),
                .init(x: rect.width - pointerHeight, y: rect.height / 2 + pointerWidth / 2),
                .init(x: rect.width, y: rect.height / 2)
            ]
            
            frame = .init(x: 0, y: 0, width: rect.width - pointerHeight, height: rect.height)
        case .trailing:
            points = [
                .init(x: pointerHeight, y: rect.height / 2 - pointerWidth / 2),
                .init(x: pointerHeight, y: rect.height / 2 + pointerWidth / 2),
                .init(x: 0, y: rect.height / 2)
            ]
            
            frame = .init(x: pointerHeight, y: 0, width: rect.width - pointerHeight, height: rect.height)
        }
        
        path.move(to: points.last ?? .zero)
        path.addLines(points)
        path.addRoundedRect(in: frame, cornerSize: .init(width: 5, height: 5))
        
        return path
    }
}

private struct CalloutButtonStyle: ButtonStyle {
    let edge: Edge
    
    fileprivate func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            if edge == .bottom {
                Color.clear
                    .frame(maxWidth: 1, maxHeight: 10)
            }
            
            HStack {
                if edge == .trailing {
                    Color.clear
                        .frame(maxWidth: 10, maxHeight: 1)
                }
                
                configuration.label
                    .padding(6)
                
                if edge == .leading {
                    Color.clear
                        .frame(maxWidth: 10, maxHeight: 1)
                }
            }
            
            if edge == .top {
                Color.clear
                    .frame(maxWidth: 1, maxHeight: 10)
            }
        }
        .background(
            CalloutBubble(edge: edge)
                .fill(configuration.isPressed ? Color(white: 0.8, opacity: 1.0) : .white)
                .shadow(radius: 2)
        )
    }
}

public struct Callout {
    public let body: (_ onTap: @escaping () -> Void) -> AnyView
    public let edge: Edge
    
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
    
    func createView(onTap: @escaping () -> Void) -> some View {
        body(onTap)
            .overlay(GeometryReader { proxy in
                Color.clear
                    .preference(key: CalloutPreferenceKey.self, value: proxy.size)
            })
    }
}
