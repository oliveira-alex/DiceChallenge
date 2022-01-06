//
//  DiceView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct DiceView: View {
    @EnvironmentObject var results: Results
    @State private var rolledNumber: Int = 0
    private var diceFace: String {
        if results.isEmpty {
            return "square"
        } else {
            return "die.face.\(results.all.last!)"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: diceFace)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding([.bottom], 135)
                
                Button(action: { rollDice() }) {
                    Text("Roll Dice")
                        .font(.title2)
                        .padding(25)
                        .background(
                            Capsule()
                                .stroke(Color.accentColor, lineWidth: 1.5)
                        )
                }
                .padding(.bottom)
            }
            .navigationTitle("Dice Simulator")
        }
    }
    
    func rollDice() {
        rolledNumber = Int.random(in: 1...6)
        results.append(rolledNumber)
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView()
            .environmentObject(Results.example)
//            .preferredColorScheme(.dark)
    }
}
