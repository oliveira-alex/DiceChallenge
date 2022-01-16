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
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            NavigationView {
                VStack {
                    Spacer(minLength: 30)
                    
                    Text(currentResult.total)
                        .font(.largeTitle)
                        .background(
                            Circle()
                                .fill(Color.primary)
                                .frame(width: 80, height: 80)
                        )
                        .foregroundColor(colorScheme == .light ? .white : .black)
                    
                    Spacer(minLength: 30)
                    
                    VStack {
                        HStack {
                            DiceView(systemName: dices.all[0].faceUpImageSFSymbolName)

                            if dices.count > 1 {
                                DiceView(systemName: dices.all[1].faceUpImageSFSymbolName)
                            }
                        }

                        if dices.count > 2 {
                            HStack {
                                if dices.count > 2 {
                                    DiceView(systemName: dices.all[2].faceUpImageSFSymbolName)
                                        .frame(maxWidth: (screenWidth - 2*screenWidth/18)/2)
                                }
                                
                                if dices.count > 3 {
                                    DiceView(systemName: dices.all[3].faceUpImageSFSymbolName)
                                }
                            }
                        }
                    }
                    .padding(screenWidth/18)
                    .frame(width: screenWidth, height: screenWidth)
                    .background(
                        RoundedRectangle(cornerRadius: geometry.size.width/8)
                            .stroke(colorScheme == .light ? .black : .white)
                            .background(
                                RoundedRectangle(cornerRadius: geometry.size.width/8)
                                    .fill(Color.secondary.opacity(0.3))
                            )
                            .padding(9)
                    )
                    
                    Spacer(minLength: 30)

                    Button(action: rollDices) {
                        Text(results.maxedOut ? "Maxed Out" : "Roll \(dices.diceOrDices)")
                            .font(.title2)
                            .background(
                                Capsule()
                                    .fill(Color.accentColor)
                                    .frame(width: 150, height: 75)
                            )
                            .foregroundColor(.white)
                    }
                    .disabled(results.maxedOut || dices.areRolling)
                    
                    Spacer(minLength: 80)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: { isShowingSettings.toggle() }) {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        VStack(spacing: 0) {
                            Image(systemName: dices.maxFaceValueSFSymbolName)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                            
                            Text("max")
                                .font(.system(size: 10))
                        }
                        .frame(width: 35, height: 35)
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
        dices.rollAll {
            if dices.areRolling {
                feedback.notificationOccurred(.success)
            } else {
                results.append(currentResult)
            }
        }
    }
}

struct DicesView_Previews: PreviewProvider {
    static var previews: some View {
        DicesView()
            .environmentObject(Dices.example)
            .environmentObject(Results.example)
//            .preferredColorScheme(.dark)
    }
}
