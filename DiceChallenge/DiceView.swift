//
//  DiceView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct DiceView: View {
    @State private var rolledNumber: Int = 0
    private var diceFace: String {
        if rolledNumber == 0 {
            return "square"
        } else {
            return "die.face.\(rolledNumber)"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: diceFace)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding([.bottom], 70)

                Button("Roll Dice") { rollDice() }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor)
                    )
            }
            .navigationTitle("Dice Simulator")
        }
    }
    
    func rollDice() {
        var newNumber: Int
        repeat {
            newNumber = Int.random(in: 1...6)
        } while (newNumber == rolledNumber)
        rolledNumber = newNumber
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView()
//            .preferredColorScheme(.dark)
    }
}
