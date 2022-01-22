//
//  SettingsView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 06/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dices: Dices
    @State private var numberOfDices = 1
    @State private var numberOfDiceFaces = 6
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    
                Spacer()
            }
            
            VStack(spacing: 10) {
                HStack {
                    Text("Quantity")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                }

                Picker("Number of dices", selection: $numberOfDices) {
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
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color.gray.opacity(0.25))
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
                
                Picker("Number of dices", selection: $numberOfDiceFaces) {
                    ForEach(Dice.possibleNumberOfFaces, id: \.self) { numberOfFaces in
                        Text("\(numberOfFaces) faces dice").tag(numberOfFaces)
                    }
                }
                .pickerStyle(.wheel)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color.gray.opacity(0.25))
                )
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.vertical)
        .onAppear {
            numberOfDices = dices.count
            numberOfDiceFaces = dices.numberOfFaces
        }
        .onChange(of: numberOfDiceFaces, perform: { newNumberOfDiceFaces in
            if newNumberOfDiceFaces != dices.numberOfFaces {
                dices.setNumberOfDiceFaces(to: newNumberOfDiceFaces)
            }
        })
        .onChange(of: numberOfDices, perform: { newNumberOfDices in
            if newNumberOfDices != dices.count {
                dices.setNumberOfDices(to: newNumberOfDices)
            }
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Dices.example)
//            .preferredColorScheme(.dark)
    }
}
