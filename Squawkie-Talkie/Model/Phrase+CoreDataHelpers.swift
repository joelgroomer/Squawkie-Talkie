//
//  Phrase+CoreDataHelpers.swift
//  Squawkie-Talkie
//
//  Created by Joel Groomer on 1/16/21.
//

import Foundation

extension Phrase {
    
    // convert Core Data types into non-optionals and standard types
    var phraseText: String {
        get {
            text ?? "New phrase"
        }
        set {
            self.text = newValue
        }
    }
    
    // convert set of `LearnedPhrase`s associated with this Phrase into an array
    var phrasesLearned: [LearnedPhrase] {
        let learnedPhrasesArray = learned?.allObjects as? [LearnedPhrase] ?? []
        return learnedPhrasesArray.sorted { $0.dateLearnedUnwrapped < $1.dateLearnedUnwrapped }
    }
    
    // for anywhere an example Phrase is needed
    static var example: Phrase {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let phrase = Phrase(context: viewContext)
        phrase.active = true
        phrase.text = "Example phrase"
        phrase.url = Bundle.main.url(forResource: "Hello", withExtension: "mp3")
        
        return phrase
    }
}
