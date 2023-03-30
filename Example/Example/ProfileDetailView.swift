//
//  ProfileDetailView.swift
//  Example
//
//  Created by Peter Murin on 29/03/2023.
//

import SwiftUI

struct ProfileDetailView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(.horizontal)
            .frame(maxHeight: 60)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.green)
            )
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView(text: "")
    }
}
