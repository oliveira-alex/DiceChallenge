//
//  ContentView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var results = Results()
    var dices = Dices()
    
    @State private var isShowingFullTabView = true
    @State private var selectedTab = "Dices"
    @State var pageTabViewIndexDisplayMode: PageTabViewStyle.IndexDisplayMode = .always
    
    var body: some View {
        GeometryReader { geometry in
            MyTabView(selectedTab: $selectedTab,
                      isShowingFullTabView: $isShowingFullTabView,
                      pageTabViewIndexDisplayMode: $pageTabViewIndexDisplayMode)
                .onChange(of: geometry.size.width) { _ in
                    isShowingFullTabView = false
                    withAnimation { pageTabViewIndexDisplayMode = .never }
                    var delayToReappear: Double = 0
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                        isShowingFullTabView = true
                        
                        #if targetEnvironment(macCatalyst)
                            delayToReappear = 0.7
                        #endif
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + delayToReappear) {
                            withAnimation { pageTabViewIndexDisplayMode = .always }
                        }
                    }
                }
                .environmentObject(dices)
                .environmentObject(results)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(results: .example, dices: .threeDices)
            .environmentObject(Dices.example)
            .environmentObject(Results.example)
        //            .preferredColorScheme(.dark)
    }
}
