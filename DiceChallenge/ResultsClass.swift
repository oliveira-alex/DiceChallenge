//
//  ResultsClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

class Results: ObservableObject {
    static let example = Results([[1],
                                  [6, 3],
                                  [2],
                                  [4, 3, 1],
                                  [5, 5, 6, 2],
                                  [5, 1],
                                  [6, 1, 5],
                                  [3]])
    
    @Published private var rolled: [[Int]] = []
    var isEmpty: Bool { return rolled.isEmpty }
    var all: [[Int]] { return rolled }
    
    init() { }
    
    convenience init(_ numbers: [[Int]]) {
        self.init()
        
        self.rolled += numbers
    }
    
    func append(_ result: [Int]) {
        rolled.append(result)
    }
    
    func removeAll() {
        rolled = []
    }
}
