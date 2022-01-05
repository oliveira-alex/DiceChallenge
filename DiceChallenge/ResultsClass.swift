//
//  ResultsClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

class Result: Identifiable {
    var id = UUID()
    var rolledNumber: Int
    
    init(_ number: Int) {
        rolledNumber = number
    }
}

class Results: ObservableObject {
    @Published var rolled: [Result] = []
    
    init() { }
    
    convenience init(_ numbers: [Int]) {
        self.init()
        
        for number in numbers {
            self.rolled.append(Result(number))
        }
    }
    
    func append(_ number: Int) {
        rolled.append(Result(number))
    }
}
