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
                ForEach(results.rolled) { result in
                    let index = results.rolled.firstIndex(where: { $0.id == result.id })!
                    
                    HStack {
                        Text("\(index + 1). ")
                        Image(systemName: "die.face.\(result.rolledNumber)")
                    }
                }
            }
            .navigationTitle("Previously Rolled")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: { results.rolled = [] }) {
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
                    .disabled(results.rolled.isEmpty)
                }
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
            .environmentObject(Results([1, 6, 2, 4, 3, 1, 5, 1, 6]))
    }
}
