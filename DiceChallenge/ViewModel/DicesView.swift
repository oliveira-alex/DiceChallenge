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
            let screenHeight = geometry.size.height
            let screenWidth = geometry.size.width
            let frameAspectRatio =  screenWidth/screenHeight
            let availableFrameWidth = frameAspectRatio > 0.65 ? 0.65*screenHeight : screenWidth
            
            NavigationView {
                VStack {
                    Spacer(minLength: 30)
                    
                    Text(dices.areRolling ? "Total" : currentResult.total)
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
                                }
                                
                                if dices.count > 3 {
                                    DiceView(systemName: dices.all[3].faceUpImageSFSymbolName)
                                }
                            }
                        }
                    }
                    .padding(availableFrameWidth/18)
                    .frame(width: availableFrameWidth, height: availableFrameWidth)
                    .background(
                        RoundedRectangle(cornerRadius: availableFrameWidth/8)
                            .stroke(colorScheme == .light ? .black : .white)
                            .background(
                                RoundedRectangle(cornerRadius: availableFrameWidth/8)
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
                            Image(systemName: "gearshape.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .background(
                                    Circle()
                                        .fill(.white)
                                )
                                .padding([.vertical], 22)
                                .frame(width: 85, height: 85, alignment: .leading)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        VStack(spacing: 0) {
                            Image(systemName: dices.maxFaceValueSFSymbolName)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                            
                            Text("max")
                                .font(.system(size: 10))
                        }
                        .frame(width: 40, height: 40)
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
            feedback.notificationOccurred(.success)
            if dices.areRolling == false {
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
