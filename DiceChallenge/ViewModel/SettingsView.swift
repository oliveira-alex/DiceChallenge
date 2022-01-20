//
//  SettingsView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 06/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dices: Dices
    @State private var newNumberOfDices = 1
    @State private var newNumberOfDiceFaces = 6
    
    var body: some View {
        NavigationView {
            Form {
                Section("Quantity") {
                    Picker("Number of dices", selection: $newNumberOfDices) {
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
                }
                
                Section("Type") {
                    Picker("Number of dices", selection: $newNumberOfDiceFaces) {
                        ForEach(Dice.possibleNumberOfFaces, id: \.self) { numberOfFaces in
                            Text("\(numberOfFaces) faces dice").tag(numberOfFaces)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .onAppear {
                newNumberOfDices = dices.count
                newNumberOfDiceFaces = dices.numberOfFaces
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomToolbarButton(title: "Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    CustomToolbarButton(title: "Apply") {
                        if newNumberOfDiceFaces != dices.numberOfFaces {
                            dices.setNumberOfDiceFaces(to: newNumberOfDiceFaces)
                        }
                        
                        if newNumberOfDices != dices.count {
                            dices.setNumberOfDices(to: newNumberOfDices)
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Dices.example)
            .preferredColorScheme(.dark)
    }
}
