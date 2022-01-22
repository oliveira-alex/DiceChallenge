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
                .frame(width: 70, height: 35)
                .background(
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor)
                    }
                )
                .foregroundColor(Color.accentColor)
        }
    }
}
