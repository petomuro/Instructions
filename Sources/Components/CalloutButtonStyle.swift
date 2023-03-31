//
//  CalloutButtonStyle.swift
//  
//
//  Created by Peter Murin on 31/03/2023.
//

import SwiftUI

struct CalloutButtonStyle: ButtonStyle {
    let edge: Edge
    
    func makeBody(configuration: Configuration) -> some View {
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
                .shadow(radius: 1)
        )
    }
}
