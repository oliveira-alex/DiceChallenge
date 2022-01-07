//
//  ResultsView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var results: Results
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(results.all.enumerated()), id: \.offset) { resultIndex, result in
                    HStack {
                        Text("\(resultIndex + 1). ")
                        
                        ForEach(Array(result.enumerated()), id: \.offset) { diceIndex, diceFaceNumber in
                            if diceIndex == 0 {
                                Image(systemName: "die.face.\(diceFaceNumber)")
                            } else {
                                Text("+")
                                Image(systemName: "die.face.\(diceFaceNumber)")
                            }
                        }
                        
                        let total = result.reduce(0, +)
                        Text("= \(total)")
                    }
                }
            }
            .navigationTitle("Previously Rolled")
            .toolbar {
                CustomToolbarButton(title: "Clear", action: results.removeAll)
                    .disabled(results.isEmpty)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
            .environmentObject(Results.example)
    }
}
