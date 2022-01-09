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
        NavigationView {
            Form {
                HStack {
                    Text("Quantity")
                    Picker("Number of dices", selection: $newNumberOfDices) {
                        ForEach(1..<5) { number in
                            switch number {
                            case 1:
                                Text("\(number) dice").tag(number)
                            default:
                                Text("\(number) dices").tag(number)
                            }
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .onAppear(perform: { newNumberOfDices = dices.count })
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomToolbarButton(title: "Cancel"){
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    CustomToolbarButton(title: "Apply") {
                        if newNumberOfDices > dices.count {
                            repeat {
                                dices.addOneDice()
                            } while newNumberOfDices > dices.count
                        } else if newNumberOfDices < dices.count {
                            repeat {
                                dices.removeOneDice()
                            } while newNumberOfDices < dices.count
                        }
                        
                        dices.resetAll()
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
            .environmentObject(Dices())
    }
}
