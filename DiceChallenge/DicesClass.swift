//
//  DicesClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 09/01/2022.
//

import Foundation

struct Dice: Identifiable, Codable {
    static let example = Dice(numberOfFaces: defaultNumberOfFaces, faceUpValue: 5)
    
    static let defaultNumberOfFaces = 6
    static let possibleNumberOfFaces = [4, 6, 8, 10, 12, 20]
    static let limiteOfIterations = 25
    static let possibleNumberOfIterations = [limiteOfIterations, limiteOfIterations/2, limiteOfIterations/4]
    
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
    var remainingIterations = 0

    init(numberOfFaces: Int, faceUpValue: Int) {
        self.numberOfFaces = numberOfFaces
        self.faceUpValue = faceUpValue
    }
    
    init(numberOfFaces: Int) {
        self.init(numberOfFaces: numberOfFaces, faceUpValue: 0)
    }
    
    init() {
        self.init(numberOfFaces: Dice.defaultNumberOfFaces, faceUpValue: 0)
    }

    mutating func roll() {
        var newFaceUpValue = 0
        repeat {
            newFaceUpValue = Int.random(in: 1...numberOfFaces)
        } while newFaceUpValue == faceUpValue
        faceUpValue = newFaceUpValue
        
        remainingIterations -= 1
    }
    
    mutating func reset() {
        faceUpValue = 0
    }
}

class Dices: ObservableObject {
    static let saveKey = "DicesChallenge.SavedDices"
    static let example = Dices(dices: [.example])
    static let singleDice = Dices(dices: [Dice()])
    static let threeDices = Dices(dices: [Dice(), Dice(), Dice()])
    
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
    private var remainingIterations: [Int] {
        var iterations: [Int] = []
        for dice in dices {
            iterations.append(dice.remainingIterations)
        }
        
        return iterations
    }
    var areRolling: Bool {
        remainingIterations.max()! > 0
    }

    init(dices: [Dice]) {
        self.dices = dices
    }
    
    func getDocumentsDirectoryURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let filename = getDocumentsDirectoryURL().appendingPathComponent(Self.saveKey)
        
        do {
            let encodedData = try JSONEncoder().encode(dices)
            try encodedData.write(to: filename, options: [.atomic])
        } catch {
            
        }
    }
    
    convenience init() {
        self.init(dices: [])
        let filename = getDocumentsDirectoryURL().appendingPathComponent(Self.saveKey)
        
        do {
            let encodedDices = try Data(contentsOf: filename)
            dices = try JSONDecoder().decode([Dice].self, from: encodedDices)
        } catch {
            dices = [Dice()]
        }
    }

    func addOneDice(numberOfFaces: Int) {
        dices.append(Dice(numberOfFaces: numberOfFaces))
        save()
    }
    
    func removeOneDice() {
        guard dices.count > 0 else { return }
        
        let _ = dices.popLast()
        save()
    }
    
    func getNewDices(numberOfFaces newNumberOfFaces: Int, numberOfDices newNumberOfDices: Int) {
        dices.removeAll()
        
        repeat {
            addOneDice(numberOfFaces: newNumberOfFaces)
        } while dices.count < newNumberOfDices
        save()
    }
    
    func resetAll() {
        for i in 0..<dices.count {
            dices[i].reset()
        }
        save()
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
    
    func rollAll(completion: @escaping(() -> Void)) {
        for n in 0..<dices.count {
            let numberOfIterations = Dice.possibleNumberOfIterations.randomElement()!
            dices[n].remainingIterations = numberOfIterations
            let initialIteration = Dice.limiteOfIterations - numberOfIterations
            
            for i in initialIteration..<Dice.limiteOfIterations {
                DispatchQueue.main.asyncAfter(deadline: .now() + pow(Double(i),1.5)/45 - pow(Double(initialIteration), 1.5)/45) { [weak self] in
                    self?.dices[n].roll()

                    completion()
                    
                    if self?.remainingIterations.max()! == 0 {
                        self?.save()
                    }
                }
            }
        }
    }
}

//extension Dices {
//    func rollAll() async -> Result {
//        return await withUnsafeContinuation { continuation in
//            self.rollAll {
//                continuation.resume(returning: Result(from: self))
//            }
//        }
//    }
//}
