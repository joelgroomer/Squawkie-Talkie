//
//  Parrot+CoreDataHelpers.swift
//  Squawkie-Talkie
//
//  Created by Joel Groomer on 1/16/21.
//

import Foundation

extension Parrot {
    
    // convert Core Data types into non-optionals and standard types
    var parrotBreed: String { breed ?? "Parrot" }
    var parrotImage: URL { image ?? URL(fileURLWithPath: "/dev/null") }
    var parrotName: String { name ?? "My Birb 💚" }
    
    // convert set of `LearnedPhrase`s to an array
    var parrotLearnedPhrases: [LearnedPhrase] {
        let learnedPhrasesArray = phrasesLearned?.allObjects as? [LearnedPhrase] ?? []
        return learnedPhrasesArray.sorted { $0.dateLearnedUnwrapped < $1.dateLearnedUnwrapped }
    }
    
    // for anywhere an example Parrot is needed
    static var example: Parrot {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let parrot = Parrot(context: viewContext)
        parrot.breed = "Example breed"
        parrot.gotchaDate = Date()
        parrot.hatchDate = Date()
        parrot.image = URL(fileURLWithPath: "/dev/null")
        parrot.name = "Example name"
        
        return parrot
    }
}
