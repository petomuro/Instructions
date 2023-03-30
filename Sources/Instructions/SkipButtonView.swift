//
//  SkipButtonView.swift
//  
//
//  Created by Peter Murin on 29/03/2023.
//

import SwiftUI

struct SkipButtonView: View {
    @EnvironmentObject private var instructions: Instructions
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    Task {
                        await instructions.stop()
                    }
                }) {
                    Text("Skip")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .shadow(radius: 1)
                        )
                }
            }
            .padding([.top, .trailing])
            
            Spacer()
        }
    }
}

struct SkipButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SkipButtonView()
    }
}
