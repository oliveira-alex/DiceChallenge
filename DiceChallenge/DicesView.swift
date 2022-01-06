//
//  DicesView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct DicesView: View {
    @EnvironmentObject var results: Results
    @Environment(\.colorScheme) var colorScheme
    @State private var numberOfDices = 3
    @State private var rolledNumber: Int = 0
    private var diceFace: String {
        if results.isEmpty {
            return "square"
        } else {
            return "die.face.\(results.all.last!)"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            NavigationView {
                VStack {
                    Spacer(minLength: 40)
                    
                    Text(results.isEmpty ? "Total" : "\(numberOfDices*rolledNumber)")
                        .font(.largeTitle)
                        .background(
                            Circle()
                                .fill(Color.primary)
                                .frame(width: 80, height: 80)
                        )
                        .foregroundColor(colorScheme == .light ? .white : .black)
                    
                    Spacer(minLength: 40)
                    
                    VStack {
                        HStack {
                            Image(systemName: diceFace)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)

                            if numberOfDices > 1 {
                                Image(systemName: diceFace)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }

                        if numberOfDices > 1 {
                            HStack {
                                if numberOfDices > 2 {
                                Image(systemName: diceFace)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                }
                                
                                if numberOfDices > 3 {
                                    Image(systemName: diceFace)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                }
                            }
                            .frame(maxWidth: screenWidth, maxHeight: (screenWidth - 2*20)/2)
                        }
                    }
                    .padding([.horizontal], 20)
                    .frame(maxWidth: screenWidth, maxHeight: screenWidth)
                    
                    Spacer(minLength: 50)

                    Button(action: { rollDices() }) {
                        Text(numberOfDices == 1 ? "Roll Dice" : "Roll Dices")
                            .font(.title2)
                            .background(
                                Capsule()
                                    .stroke(Color.accentColor, lineWidth: 1.5)
                                    .frame(width: 150, height: 75)
                            )
                    }
                    
                    Spacer(minLength: 50)
                }
                .navigationTitle("Dice Simulator")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: changeNumberOfDices) {
                            Text("Settings")
                                .padding([.vertical], 3)
                                .padding([.horizontal], 11)
                                .background(
                                    HStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.accentColor)
                                    }
                                )
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    func rollDices() {
        rolledNumber = Int.random(in: 1...6)
        results.append(rolledNumber)
    }
    
    func changeNumberOfDices() {
        if numberOfDices < 4 {
            numberOfDices += 1
        } else {
            numberOfDices = 1
        }
    }
}

struct DicesView_Previews: PreviewProvider {
    static var previews: some View {
        DicesView()
            .environmentObject(Results())
//            .preferredColorScheme(.dark)
    }
}
