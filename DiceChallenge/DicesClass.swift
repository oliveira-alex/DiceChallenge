//
//  DicesClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 09/01/2022.
//

import Foundation

class Dice: Identifiable, Codable {
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
        var newFaceUpValue = 0
        repeat {
            newFaceUpValue = Int.random(in: 1...numberOfFaces)
        } while newFaceUpValue == faceUpValue
        
        faceUpValue = newFaceUpValue
    }
    
    func reset() {
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
    @Published private var remainingIterations = 0
    var areRolling: Bool {
        remainingIterations > 0
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
        for dice in dices {
            dice.reset()
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
        let limiteOfIterations = 21
        let initialIteration = [0, 7, 14].randomElement()!
        remainingIterations = limiteOfIterations - initialIteration
        
        for i in initialIteration..<limiteOfIterations {
            DispatchQueue.main.asyncAfter(deadline: .now() + pow(Double(i),1.5)/50 - pow(Double(initialIteration), 1.5)/50) {
                for dice in self.dices {
                    dice.roll()
                }
                
                self.remainingIterations -= 1
                completion()
                
                if self.remainingIterations == 0 {
                    self.save()
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
