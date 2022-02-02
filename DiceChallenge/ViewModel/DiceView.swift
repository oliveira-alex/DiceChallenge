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
            let frameWidth = geometry.size.width
            let frameHeight = geometry.size.height
            let smallestLenght = (frameWidth < frameHeight) ? frameWidth : frameHeight

            Image(systemName: systemName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .background(
                    RoundedRectangle(cornerRadius: smallestLenght / 8, style: .continuous)
                        .fill((colorScheme == .light) ? .white : .black)
                        .padding(10)
                )
                .frame(width: smallestLenght, height: smallestLenght)
                .centered()
        }
    }
}

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer(minLength: 0)
            HStack {
                Spacer(minLength: 0)
                content
                Spacer(minLength: 0)
            }
            Spacer(minLength: 0)
        }
    }
}

extension View {
    func centered() -> some View {
        modifier(CenterModifier())
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(systemName: "die.face.5")
//            .preferredColorScheme(.dark)
    }
}
