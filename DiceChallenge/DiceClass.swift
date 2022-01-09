//
//  DiceClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 09/01/2022.
//

import SwiftUI

class Dice: Identifiable {
    var id = UUID()
    var numberOfFaces = 6
    var faceUpValue = 0
    var faceUpImage: Image {
        if faceUpValue == 0 {
            return Image(systemName: "square")
        } else if numberOfFaces == 6 {
            return Image(systemName: "die.face.\(faceUpValue)")
        } else {
            return Image(systemName: "\(faceUpValue).square")
        }
    }
    
    init() { }
    
    convenience init(faceUpValue: Int) {
        self.init()
        
        self.faceUpValue = faceUpValue
    }
    
    convenience init(numberOfFaces: Int) {
        self.init()
        
        self.numberOfFaces = numberOfFaces
    }
    
    convenience init(numberOfFaces: Int, faceUpValue: Int) {
        self.init()
        
        self.numberOfFaces = numberOfFaces
        self.faceUpValue = faceUpValue
    }
    
    func roll() {
        faceUpValue = Int.random(in: 1...numberOfFaces)
    }
    
    func reset() {
        faceUpValue = 0
    }
}

class Dices: ObservableObject {
    @Published private var dices = [Dice()]
    var first: Dice { return dices.first! }
    var all: [Dice] { return dices }
    var count: Int { return dices.count }
    
    func addOneDice() {
        dices.append(Dice())
    }
    
    func removeOneDice() {
        let _ = dices.popLast()
    }
    
    func rollAll() {
        for dice in dices {
            dice.roll()
        }
    }
    
    func resetAll() {
        for dice in dices {
            dice.reset()
        }
    }
}
