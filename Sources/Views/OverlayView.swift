//
//  OverlayView.swift
//  
//
//  Created by Peter Murin on 29/03/2023.
//

import SwiftUI

struct OverlayView: View {
    var body: some View {
        Color(white: 0.8, opacity: 0.5)
            .edgesIgnoringSafeArea(.all)
    }
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView()
    }
}
