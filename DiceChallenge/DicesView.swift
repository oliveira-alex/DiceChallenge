//
//  DicesView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct DicesView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dices: Dices
    @EnvironmentObject var results: Results

    @State private var isShowingSettings = false

    private var currentResult: Result { Result(from: dices) }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            NavigationView {
                VStack {
                    Spacer(minLength: 40)
                    
                    Text(currentResult.total)
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
                            dices.all[0].faceUpImage
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)

                            if dices.count > 1 {
                                dices.all[1].faceUpImage
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }

                        if dices.count > 1 {
                            HStack {
                                if dices.count > 2 {
                                    dices.all[2].faceUpImage
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                }
                                
                                if dices.count > 3 {
                                    dices.all[3].faceUpImage
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

                    Button(action: rollDices) {
                        Text(dices.count > 1 ? "Roll Dices" : "Roll Dice")
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
                        CustomToolbarButton(title: "Settings", action: { isShowingSettings.toggle() })
                    }
                }
                .sheet(isPresented: $isShowingSettings) {
                    SettingsView()
                        .environmentObject(dices)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    func rollDices() {
        dices.rollAll()
        
        results.append(currentResult)
    }
}

struct DicesView_Previews: PreviewProvider {
    static var previews: some View {
        DicesView()
            .environmentObject(Dices())
            .environmentObject(Results())
//            .preferredColorScheme(.dark)
    }
}
