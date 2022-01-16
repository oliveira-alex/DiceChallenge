//
//  DiceView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 16/01/2022.
//

import SwiftUI

struct DiceView: View {
    @Environment(\.colorScheme) var colorScheme
    var systemName: String
    
    var body: some View {
        GeometryReader { geometry in
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .background(
                    RoundedRectangle(cornerRadius: geometry.size.width/8, style: .continuous)
                        .fill(colorScheme == .light ? .white : .black)
                        .padding(10)
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(systemName: "die.face.5")
//            .preferredColorScheme(.dark)
    }
}
