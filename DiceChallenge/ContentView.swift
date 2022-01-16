//
//  ContentView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct ContentView: View {
    var results = Results()
    var dices = Dices()
    
    var body: some View {
        TabView {
            DicesView()
                .tabItem {
                    Image(systemName: "dice")
                    Text("Dice")
                }
            
            ResultsView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                    Text("Results")
                }
        }
        .environmentObject(dices)
        .environmentObject(results)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(results: .example, dices: .example)
    }
}
