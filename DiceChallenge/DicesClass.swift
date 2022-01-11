//
//  DicesClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 09/01/2022.
//

import Foundation

class Dice: Identifiable {
    static let example = Dice(numberOfFaces: defaultNumberOfFaces, faceUpValue: 5)
    
    static let defaultNumberOfFaces = 6
    static let possibleNumberOfFaces = [4, 6, 8, 10, 12, 20]
    var id = UUID()
    let numberOfFaces: Int
    var faceUpValue: Int
    var faceUpImageSFSymbolName: String {
        if faceUpValue == 0 {
            return "square"
        } else if numberOfFaces == 6 {
            return "die.face.\(faceUpValue)"
        } else {
            return "\(faceUpValue).square"
        }
    }

    init(numberOfFaces: Int, faceUpValue: Int) {
        self.numberOfFaces = numberOfFaces
        self.faceUpValue = faceUpValue
    }
    
    convenience init(numberOfFaces: Int) {
        self.init(numberOfFaces: numberOfFaces, faceUpValue: 0)
    }
    
    convenience init() {
        self.init(numberOfFaces: Dice.defaultNumberOfFaces, faceUpValue: 0)
    }

    func roll() {
        faceUpValue = Int.random(in: 1...numberOfFaces)
    }
    
    func reset() {
        faceUpValue = 0
    }
}

class Dices: ObservableObject {
    static let example = Dices(dices: [.example])
    static let singleDice = Dices(dices: [Dice()])
    
    @Published private var dices: [Dice]
    var all: [Dice] { return dices }
    var count: Int { return dices.count }
    var numberOfFaces: Int {
        return dices.first!.numberOfFaces
    }
    var diceOrDices: String {
        return dices.count > 1 ? "Dices" : "Dice"
    }
    var maxFaceValueSFSymbolName: String {
        return (numberOfFaces == 6) ? "die.face.6" : "\(numberOfFaces).square"
    }

    init(dices: [Dice]) {
        self.dices = dices
    }
    
    convenience init() {
        self.init(dices: [])
    }

    func addOneDice(numberOfFaces: Int) {
        dices.append(Dice(numberOfFaces: numberOfFaces))
    }
    
    func removeOneDice() {
        guard dices.count > 0 else { return }
        
        let _ = dices.popLast()
    }
    
    func getNewDices(numberOfFaces newNumberOfFaces: Int, numberOfDices newNumberOfDices: Int) {
        dices.removeAll()
        
        repeat {
            addOneDice(numberOfFaces: newNumberOfFaces)
        } while dices.count < newNumberOfDices
    }
    
    func setNumberOfDices(to newNumberOfDices: Int) {
        if newNumberOfDices > dices.count {
            repeat {
                addOneDice(numberOfFaces: numberOfFaces)
            } while newNumberOfDices > dices.count
        } else if newNumberOfDices < dices.count {
            repeat {
                removeOneDice()
            } while newNumberOfDices < dices.count
        }
        
        resetAll()
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
