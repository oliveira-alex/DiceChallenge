//
//  SettingsView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 06/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dices: Dices
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack(spacing: 0) {
            #if !os(watchOS)
            HStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    
                Spacer()
            }
            #endif
            
            VStack(spacing: 10) {
                #if !os(watchOS)
                HStack {
                    Text("Quantity")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                }

                Picker("Number of dices", selection: $settings.numberOfDices) {
                    ForEach(1..<5) { numberOfDices in
                        switch numberOfDices {
                        case 1:
                            Text("\(numberOfDices) dice").tag(numberOfDices)
                        default:
                            Text("\(numberOfDices) dices").tag(numberOfDices)
                        }
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color.gray.opacity(0.2))
                )
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: 15)
                
                HStack {
                    Text("Type")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                #endif
                Picker("Number of dice faces", selection: $settings.numberOfDiceFaces) {
                    ForEach(Dice.possibleNumberOfFaces, id: \.self) { numberOfFaces in
                        Text("\(numberOfFaces)-sided dice").tag(numberOfFaces)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                #if os(watchOS)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 3)
                        .foregroundColor(.init(.sRGB, white: 0.1, opacity: 1))
                )
                #endif
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.gray.opacity(0.2))
                )
                .padding(.horizontal)
            }
            #if !os(watchOS)
            Spacer()
            #endif
        }
        .padding(.vertical)
        .onAppear {
            settings.numberOfDices = dices.count
            settings.numberOfDiceFaces = dices.numberOfFaces
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Dices.example)
            .environmentObject(Settings())
        
        SettingsView()
            .environmentObject(Dices.example)
            .environmentObject(Settings())
            .environment(\.locale, .init(identifier: "pt-BR"))
            .preferredColorScheme(.dark)
    }
}
