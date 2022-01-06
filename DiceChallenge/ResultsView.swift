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
                ForEach(Array(results.all.enumerated()), id: \.offset) { index, rolledNumber in
                    HStack {
                        Text("\(index + 1). ")
                        Image(systemName: "die.face.\(rolledNumber)")
                    }
                }
            }
            .navigationTitle("Previously Rolled")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: results.removeAll) {
                        Text("Clear")
                            .padding([.vertical], 3)
                            .padding([.horizontal], 11)
                            .background(
                                HStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.accentColor)
                                }
                            )
                    }
                    .disabled(results.isEmpty)
                }
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
