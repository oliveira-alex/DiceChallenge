//
//  ResultsClass.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import Foundation

struct Result: Identifiable, Codable, Equatable {
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
        // swiftlint:disable:next force_unwrapping
        numberOfDiceFaces = Dice.possibleNumberOfFaces.randomElement()!

        faceUpValues = [Int].init(repeating: Int.random(in: 1...numberOfDiceFaces), count: numberOfDices)
    }

    init(from dices: Dices) {
        numberOfDiceFaces = dices.numberOfFaces

        for dice in dices.all where dice.faceUpValue != 0 {
            faceUpValues.append(dice.faceUpValue)
        }
    }

    static func == (lhs: Result, rhs: Result) -> Bool {
        lhs.faceUpValues == rhs.faceUpValues
    }
}

class Results: ObservableObject {
    static let saveKey = "DicesChallenge.SavedResults"
    static let example = Results(results: [
        Result(numberOfDices: 1),
        Result(numberOfDices: 2),
        Result(numberOfDices: 1),
        Result(numberOfDices: 3),
        Result(numberOfDices: 4),
        Result(numberOfDices: 2),
        Result(numberOfDices: 3),
        Result(numberOfDices: 1)
    ])

    @Published private var results: [Result] = []

    var isEmpty: Bool { return results.isEmpty }
    var count: Int { return results.count }
    var all: [Result] { return results }
    var maxedOut: Bool { return results.count >= 99 }

    init(results: [Result]) {
        self.results = results
    }

    func getDocumentsDirectoryURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func save() {
        let filename = getDocumentsDirectoryURL().appendingPathComponent(Self.saveKey)

        do {
            let encodedResults = try JSONEncoder().encode(results)
            try encodedResults.write(to: filename, options: [.atomic])
        } catch {
            // error encode / save
        }
    }

    convenience init() {
        self.init(results: [])

        let filename = getDocumentsDirectoryURL().appendingPathComponent(Self.saveKey)
        do {
            let encodedResults = try Data(contentsOf: filename)
            results = try JSONDecoder().decode([Result].self, from: encodedResults)
        } catch {
            // error encode / save
        }
    }

    func append(_ result: Result) {
        results.append(result)
        save()
    }

    func removeAll() {
        results.removeAll()
        save()
    }
}
