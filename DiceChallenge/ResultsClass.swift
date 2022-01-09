//
//  ResultsClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct Result: Identifiable {
    var id = UUID()
    var numberOfDiceFaces = 6
    var faceUpValues: [Int] = []
    var faceUpImages: [Image] {
        var images: [Image] = []
        for faceUpValue in faceUpValues {
            if numberOfDiceFaces == 6 {
                images.append(Image(systemName: "die.face.\(faceUpValue)"))
            } else {
                images.append(Image(systemName: "\(faceUpValue).square"))
            }
        }
        
        return images
    }
    var total: String {
        guard !faceUpValues.isEmpty else { return "Total" }
        
        var totalValue = 0
        for number in faceUpValues {
            totalValue += number
        }
        
        return "\(totalValue)"
    }
    
    init() { }
    
    init(numberOfDices: Int) {
        numberOfDiceFaces = 6
        
        faceUpValues = [Int].init(repeating: Int.random(in: 1...numberOfDiceFaces), count: numberOfDices)
        
        
    }
    
    init(from dices: Dices) {
        numberOfDiceFaces = dices.first.numberOfFaces
        
        for dice in dices.all {
            if dice.faceUpValue != 0 {
                faceUpValues.append(dice.faceUpValue)
            }
        }
    }
}

class Results: ObservableObject {
    static let example = Results([Result(numberOfDices: 1),
                                  Result(numberOfDices: 2),
                                  Result(numberOfDices: 1),
                                  Result(numberOfDices: 3),
                                  Result(numberOfDices: 4),
                                  Result(numberOfDices: 2),
                                  Result(numberOfDices: 3),
                                  Result(numberOfDices: 1)])
    
    @Published private var results: [Result] = []
    
    var isEmpty: Bool { return results.isEmpty }
    var all: [Result] { return results }
    
    init() { }
    
    convenience init(_ results: [Result]) {
        self.init()
        
        self.results += results
    }
    
    func append(_ result: Result) {
        results.append(result)
    }
    
    func removeAll() {
        results.removeAll()
    }
}
