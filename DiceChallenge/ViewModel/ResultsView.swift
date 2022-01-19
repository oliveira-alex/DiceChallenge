//
//  ResultsView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var dices: Dices
    @EnvironmentObject var results: Results
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(results.all.enumerated()), id: \.offset) { resultIndex, result in
                    HStack {
                        Text("\(resultIndex + 1). ")
                            .frame(width: 30, alignment: .leading)
                        
                        ForEach(Array(result.faceUpImageSFSymbolNames.enumerated()), id: \.offset) { diceIndex, faceUpImageSFSymbolName in
                            if diceIndex != 0 { Text("+") }
                            
                            Image(systemName: faceUpImageSFSymbolName)
                        }
                        
                        Text("= \(result.total)")
                        
                        Spacer()
                        
                        VStack(spacing: 0) {
                            Image(systemName: result.maxFaceValueSFSymbolName)
                            
                            Text("max")
                                .font(.system(size: 8))
                        }
                        
                    }
                }
            }
            .navigationTitle("Previously Rolled")
            .toolbar {
                CustomToolbarButton(title: "Clear") {
                    results.removeAll()
                    dices.resetAll()
                }
                .disabled(results.isEmpty)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
            .environmentObject(Dices.example)
            .environmentObject(Results.example)
    }
}
