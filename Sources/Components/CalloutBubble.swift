//
//  CalloutBubble.swift
//  
//
//  Created by Peter Murin on 31/03/2023.
//

import SwiftUI

struct CalloutBubble: Shape {
    let edge: Edge
    
    func path(in rect: CGRect) -> Path {
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
        path.addRoundedRect(in: frame, cornerSize: .init(width: 10, height: 10))
        
        return path
    }
}
