//
//  CustomButton.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 06/01/2022.
//

import SwiftUI

struct CustomToolbarButton: View {
    var title: LocalizedStringKey
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.vertical, 3)
                .padding(.horizontal, 11)
                .background(
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor)
                    }
                )
        }
    }
}
