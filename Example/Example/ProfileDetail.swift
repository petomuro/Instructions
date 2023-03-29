//
//  ProfileDetail.swift
//  Example
//
//  Created by Peter Murin on 29/03/2023.
//

import SwiftUI

struct ProfileDetail: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(.horizontal)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(.green)
            )
    }
}

struct ProfileDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetail(text: "")
    }
}
