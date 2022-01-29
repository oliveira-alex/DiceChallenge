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
    @EnvironmentObject var settings: Settings
    @Binding var selectedTab: String

    @State private var isShowingSettings = false
    private var currentResult: Result { Result(from: dices) }
    #if os(iOS)
    @State private var feedback = UINotificationFeedbackGenerator()
    #endif
    @State private var isShowingAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let frameAspectRatio =  screenWidth/screenHeight
            #if os(watchOS)
            let availableFrameWidth = screenWidth
            #else
            let availableFrameWidth = (frameAspectRatio > 0.65) ? 0.65*screenHeight : screenWidth
            #endif
            
            VStack {
                #if !os(watchOS)
                Button {
                    withAnimation { selectedTab = "Settings" }
                } label: {
                    HStack {
                        HStack(alignment: .top, spacing: 3) {
                            Text(String(localized: "\(dices.count)", comment: "No action required"))
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
                    }

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
                #endif
                
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
                
                #if !os(watchOS)
                Spacer(minLength: 30)
                
                Button(action: rollDices) {
                    ((dices.count > 1) ? Text("Roll Dices") : Text("Roll Dice"))
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
                #endif
            }
            .centered()
            .alert("History Maxed Out", isPresented: $isShowingAlert) {
                Button("Later", role: .cancel) {
                    withAnimation { selectedTab = "Results" }
                }
                Button("Clear", role: .destructive) {
                    results.removeAll()
                    dices.resetAll()
                }
            } message: {
                Text("Clear history to enable more dice rolls")
            }
            #if os(watchOS)
            .onTapGesture {
                if !results.maxedOut && !dices.areRolling {
                    rollDices()
                }
            }
            #endif
            .gesture (
                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded { dragAmount in
                        if !results.maxedOut && !dices.areRolling {
                            if dragAmount.translation.height < 0 {
                                rollDices()
                            }
                        }
                    }
            )
            .onAppear {
                if settings.numberOfDiceFaces != dices.numberOfFaces {
                    dices.setNumberOfDiceFaces(to: settings.numberOfDiceFaces)
                }
                if settings.numberOfDices != dices.count {
                    dices.setNumberOfDices(to: settings.numberOfDices)
                }
            }
        }
    }
        
    
    func rollDices() {
        dices.rollAll {
            if dices.areRolling {
                #if os(iOS)
                feedback.notificationOccurred(.success)
                #endif
            } else {
                results.append(currentResult)
                
                if results.maxedOut {
                    isShowingAlert.toggle()
                }
            }
        }
    }
}

struct DicesView_Previews: PreviewProvider {
    static var previews: some View {
        DicesView(selectedTab: .constant("Dices"))
            .environmentObject(Dices.threeDices)
            .environmentObject(Results.example)
//            .preferredColorScheme(.dark)
    }
}
