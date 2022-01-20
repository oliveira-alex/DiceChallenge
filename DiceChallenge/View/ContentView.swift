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
    
    @State private var selectedTab = "Dices"
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $selectedTab) {
                DicesView()
                    .tabItem {
                        Image(systemName: "dice")
                        Text(dices.count > 1 ? "Dices" : "Dice")
                    }
                    .tag("Dices")
                
                ResultsView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.portrait")
                        Text("Results")
                    }
                    .tag("Results")
            }
            .environmentObject(dices)
            .environmentObject(results)
            .centered()
            .gesture(
                DragGesture(minimumDistance: 70, coordinateSpace: .global)
                    .onChanged { dragAmount in
                        let horizontalDragAmount = dragAmount.translation.width

                        if abs(horizontalDragAmount) > 100 {
                            if horizontalDragAmount < 0 {
                                // Left Swipe
                                if selectedTab != "Results" {
                                    withAnimation { selectedTab = "Results" }
                                }
                            } else if horizontalDragAmount > 0 {
                                // Right Swipe
                                if selectedTab != "Dices" {
                                    withAnimation { selectedTab = "Dices" }
                                }
                            }
                        }
                    }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(results: .example, dices: .example)
    }
}
