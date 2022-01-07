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
    @State private var isShowingSettings = false
    @State private var numberOfDices = 1
    @State private var rolledNumbers: [Int] = []
    var totalRolled: Int? {
        if newSettings {
            return nil
        } else {
            var total = 0
            for diceNumber in 0..<numberOfDices {
                total += results.all.last![diceNumber]
            }
            
            return total
        }
    }
    private var newSettings: Bool {
        results.isEmpty || (results.all.last!.count != numberOfDices)
    }
    private var diceFaces: [String] {
        var faces: [String] = []
        if newSettings {
            for _ in 0..<numberOfDices {
                faces.append("square")
            }
        } else {
            for faceNumber in results.all.last! {
                faces.append("die.face.\(faceNumber)")
            }
        }
        
        return faces
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            NavigationView {
                VStack {
                    Spacer(minLength: 40)
                    
                    Text(newSettings ? "Total" : "\(totalRolled!)")
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
                            Image(systemName: diceFaces[0])
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)

                            if numberOfDices > 1 {
                                Image(systemName: diceFaces[1])
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }

                        if numberOfDices > 1 {
                            HStack {
                                if numberOfDices > 2 {
                                Image(systemName: diceFaces[2])
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                }
                                
                                if numberOfDices > 3 {
                                    Image(systemName: diceFaces[3])
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
                        CustomToolbarButton(title: "Settings", action: showSettingsSheet)
                    }
                }
                .sheet(isPresented: $isShowingSettings) {
                    SettingsView(numberOfDices: $numberOfDices)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    func rollDices() {
        rolledNumbers = []
        for _ in 0..<numberOfDices {
            rolledNumbers.append(Int.random(in: 1...6))
        }
        
        results.append(rolledNumbers)
    }
    
    func showSettingsSheet() { isShowingSettings.toggle() }
}

struct DicesView_Previews: PreviewProvider {
    static var previews: some View {
        DicesView()
            .environmentObject(Results.example)
//            .preferredColorScheme(.dark)
    }
}
