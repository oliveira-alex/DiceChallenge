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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("History")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical)
                
                Spacer()
                
                CustomToolbarButton(title: "Clear") {
                    isShowingAlert.toggle()
                }
                .disabled(results.isEmpty)
                .alert("Clear history", isPresented: $isShowingAlert) {
                    Button("Cancel", role: .cancel) { }
                    
                    Button("Clear", role: .destructive) {
                        results.removeAll()
                        dices.resetAll()
                    }
                } message: {
                    Text("This will clear all results")
                }
            }
            .padding([.vertical])
            
            List(Array(results.all.enumerated()), id: \.offset) { resultIndex, result in
                HStack {
                    Text("\(resultIndex + 1). ")
                        .frame(width: 26, alignment: .leading)
                    
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
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .background(Color.gray.opacity(0.25))
            .clipShape(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
            )

            Spacer(minLength: 60)
        }
        .padding(.horizontal)
    }
}


struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
            .environmentObject(Dices.example)
            .environmentObject(Results.example)
//            .preferredColorScheme(.dark)
        
        SettingsView()
            .environmentObject(Dices.example)
//            .preferredColorScheme(.dark)
    }
}
