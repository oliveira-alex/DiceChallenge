//
//  SettingsView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 06/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var numberOfDices: Int
    @State private var pickerIndex = 0
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Quantity")
                    Picker("Number of dices", selection: $pickerIndex) {
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
            .onAppear(perform: { pickerIndex = numberOfDices })
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomToolbarButton(title: "Cancel") { presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    CustomToolbarButton(title: "Apply") { presentationMode.wrappedValue.dismiss()
                        numberOfDices = pickerIndex
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(numberOfDices: .constant(3))
    }
}
