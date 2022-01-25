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
            let availableFrameWidth = (frameAspectRatio > 0.65) ? 0.65*screenHeight : screenWidth
            
            VStack {
                HStack {
                    HStack(alignment: .top, spacing: 3) {
                        Text("\(dices.count)")
                            .font(.title)
                            
                        VStack(spacing: 0) {
                            Image(systemName: dices.maxFaceValueSFSymbolName)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)

                            Text("max")
                                .font(.system(size: 10))
                        }
                    }
                    .frame(width: 50, height: 40)
                    .padding([.top, .horizontal])

                    Spacer()
                }
                
                Text(dices.areRolling ? "Total" : currentResult.total)
                    .font(.largeTitle)
                    .background(
                        Circle()
                            .fill(Color.primary)
                            .frame(width: 80, height: 80)
                    )
                    .foregroundColor((colorScheme == .light) ? .white : .black)
                
                Spacer(minLength: 30)
                
                VStack(spacing: 0.06*availableFrameWidth) {
                    HStack(spacing: 0.06*availableFrameWidth) {
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
                .padding(0.06*availableFrameWidth)
                .frame(width: 0.9*availableFrameWidth, height: 0.9*availableFrameWidth)
                    .background(
                        RoundedRectangle(cornerRadius: availableFrameWidth/7)
                            .fill(Color.gray.opacity(0.25))
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
                
                Spacer(minLength: 93)
            }
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
            .environmentObject(Dices.threeDices)
            .environmentObject(Results.example)
.previewInterfaceOrientation(.portrait)
//            .preferredColorScheme(.dark)
    }
}
