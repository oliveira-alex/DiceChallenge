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
    @State private var newNumberOfDices = 0
    @State private var newNumberOfDiceFaces = 6
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
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
                        .frame(width: 0.82*screenWidth)
                    }
                    
                    Section("Type") {
                        Picker("Number of dices", selection: $newNumberOfDiceFaces) {
                            ForEach(Dice.possibleNumberOfFaces, id: \.self) { numberOfFaces in
                                switch newNumberOfDices {
                                case 1:
                                    Text("\(numberOfFaces) faces dice").tag(numberOfFaces)
                                default:
                                    Text("\(numberOfFaces) faces dices").tag(numberOfFaces)
                                }
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 0.82*screenWidth)
                    }
                }
                .onAppear(perform: {
                    newNumberOfDices = dices.count
                    newNumberOfDiceFaces = dices.numberOfFaces
                })
                .navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        CustomToolbarButton(title: "Cancel"){
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CustomToolbarButton(title: "Apply") {
                            if newNumberOfDiceFaces != dices.numberOfFaces {
                                dices.removeAllDices()
                                
                                repeat {
                                    dices.addOneDice(numberOfFaces: newNumberOfDiceFaces)
                                } while newNumberOfDices > dices.count
                            } else if newNumberOfDices > dices.count {
                                repeat {
                                    dices.addOneDice(numberOfFaces: newNumberOfDiceFaces)
                                } while newNumberOfDices > dices.count
                                
                                dices.resetAll()
                            } else if newNumberOfDices < dices.count {
                                repeat {
                                    dices.removeOneDice()
                                } while newNumberOfDices < dices.count
                                
                                dices.resetAll()
                            }
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Dices.example)
    }
}
