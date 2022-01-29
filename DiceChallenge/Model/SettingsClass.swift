//
//  SettingsClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 28/01/2022.
//

import Foundation

class Settings: ObservableObject {
    @Published var numberOfDices = 1
    @Published var numberOfDiceFaces = 6
}
