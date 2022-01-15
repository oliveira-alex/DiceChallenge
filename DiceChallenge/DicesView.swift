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
                            Image(systemName: dices.all[0].faceUpImageSFSymbolName)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)

                            if dices.count > 1 {
                                Image(systemName: dices.all[1].faceUpImageSFSymbolName)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }

                        if dices.count > 1 {
                            HStack {
                                if dices.count > 2 {
                                    Image(systemName: dices.all[2].faceUpImageSFSymbolName)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                }
                                
                                if dices.count > 3 {
                                        Image(systemName: dices.all[3].faceUpImageSFSymbolName)
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
                        Text(results.maxedOut ? "Maxed Out" : "Roll \(dices.diceOrDices)")
                            .font(.title2)
                            .background(
                                Capsule()
                                    .stroke(Color.accentColor, lineWidth: 1.5)
                                    .frame(width: 150, height: 75)
                            )
                    }
                    .disabled(results.maxedOut || dices.areRolling)
                    
                    Spacer(minLength: 50)
                }
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
        dices.rollAll()

        Task {
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            results.append(currentResult)
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
