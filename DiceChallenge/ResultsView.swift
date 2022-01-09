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
                        
                        ForEach(Array(result.faceUpImages.enumerated()), id: \.offset) { diceIndex, faceUpImage in
                            if diceIndex != 0 { Text("+") }
                            faceUpImage
                        }
                        
                        Text("= \(result.total)")
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
            .environmentObject(Dices())
            .environmentObject(Results.example)
    }
}
