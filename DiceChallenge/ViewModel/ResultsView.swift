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
    @State private var isShowingAlert = false
    @Binding var selectedTab: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text("History")
                    #if os(watchOS)
                    .font(.title3)
                    #else
                    .font(.largeTitle)
                    #endif
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                Spacer()
                
                #if !os(watchOS)
                CustomToolbarButton(title: "Clear") {
                    isShowingAlert.toggle()
                }
                .disabled(results.isEmpty)
                #endif
            }
            #if !os(watchOS)
            .padding(.top, 50)
            #endif
            
            List(Array(results.all.reversed().enumerated()), id: \.offset) { resultIndex, result in
                HStack {
                    Text(String(localized: "\(results.count - resultIndex). ", comment: "No translation required"))
                        .frame(width: 26, alignment: .leading)
                    
                    ForEach(Array(result.faceUpImageSFSymbolNames.enumerated()), id: \.offset) { diceIndex, faceUpImageSFSymbolName in
                        if diceIndex != 0 { Text(String(localized: "+", comment: "No translation required")) }
                        Image(systemName: faceUpImageSFSymbolName)
                    }
                    #if !os(watchOS)
                    Text(String(localized: "= \(result.total)", comment: "No translation required"))
                    #endif
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Image(systemName: result.maxFaceValueSFSymbolName)
                        
                        Text("max")
                            .font(.system(size: 8))
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .background(Color.gray.opacity(0.2))
            .clipShape(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
            )
            .alert("Clear History", isPresented: $isShowingAlert) {
                Button("Cancel", role: .cancel) { }
                
                Button("Clear", role: .destructive) {
                    results.removeAll()
                    dices.resetAll()
                    withAnimation { selectedTab = "Dices" }
                }
            } message: {
                Text("This will erase all previous results")
            }
            .onTapGesture {
                isShowingAlert.toggle()
            }
            
            #if !os(watchOS)
            Spacer(minLength: 60)
            #endif
        }
        .padding(.horizontal)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(selectedTab: .constant("Results"))
            .environmentObject(Dices.example)
            .environmentObject(Results.example)
            .environment(\.locale, .init(identifier: "pt-BR"))
//            .preferredColorScheme(.dark)
        
//        SettingsView()
//            .environmentObject(Dices.example)
//            .environmentObject(Settings())
//            .preferredColorScheme(.dark)
    }
}
