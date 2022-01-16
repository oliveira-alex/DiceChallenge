//
//  ResultsClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import Foundation

struct Result: Identifiable {
    var id = UUID()
    var numberOfDiceFaces = 6
    var faceUpValues: [Int] = []
    var faceUpImageSFSymbolNames: [String] {
        var imagesSFSymbolNames: [String] = []
        for faceUpValue in faceUpValues {
            if numberOfDiceFaces == 6 {
                imagesSFSymbolNames.append("die.face.\(faceUpValue)")
            } else {
                imagesSFSymbolNames.append("\(faceUpValue).square")
            }
        }
        
        return imagesSFSymbolNames
    }
    var maxFaceValueSFSymbolName: String {
        return (numberOfDiceFaces == 6) ? "die.face.6" : "\(numberOfDiceFaces).square"
    }
    var total: String {
        guard !faceUpValues.isEmpty else { return "Total" }
        
        var totalValue = 0
        for number in faceUpValues {
            totalValue += number
        }
        
        return "\(totalValue)"
    }
    
    init(numberOfDices: Int) {
        numberOfDiceFaces = Dice.possibleNumberOfFaces.randomElement()!
        
        faceUpValues = [Int].init(repeating: Int.random(in: 1...numberOfDiceFaces), count: numberOfDices)
        
        
    }
    
    init(from dices: Dices) {
        numberOfDiceFaces = dices.numberOfFaces
        
        for dice in dices.all {
            if dice.faceUpValue != 0 {
                faceUpValues.append(dice.faceUpValue)
            }
        }
    }
    
    init() { }
}

class Results: ObservableObject {
    static let example = Results(results: [Result(numberOfDices: 1),
                                           Result(numberOfDices: 2),
                                           Result(numberOfDices: 1),
                                           Result(numberOfDices: 3),
                                           Result(numberOfDices: 4),
                                           Result(numberOfDices: 2),
                                           Result(numberOfDices: 3),
                                           Result(numberOfDices: 1)])
    
    @Published private var results: [Result] = []
    
    var isEmpty: Bool { return results.isEmpty }
    var count: Int { return results.count }
    var all: [Result] { return results }
    var maxedOut: Bool { return results.count >= 99 }
    
    init(results: [Result]) {
        self.results = results
    }
    
    convenience init() {
        self.init(results: [])
    }
    
    func append(_ result: Result) {
        results.append(result)
    }
    
    func removeAll() {
        results.removeAll()
    }
}
