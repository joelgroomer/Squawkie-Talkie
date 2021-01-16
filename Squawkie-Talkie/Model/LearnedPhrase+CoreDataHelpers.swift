//
//  LearnedPhrase+CoreDataHelpers.swift
//  Squawkie-Talkie
//
//  Created by Joel Groomer on 1/16/21.
//

import Foundation

extension LearnedPhrase {
    
    // convert Core Data types into non-optionals and standard types
    var dateLearnedUnwrapped: Date { dateLearned ?? Date() }
    
    // for anywhere an example LearnedPhrase is needed
    static var example: LearnedPhrase {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let learnedPhrase = LearnedPhrase(context: viewContext)
        learnedPhrase.dateLearned = Date()
        learnedPhrase.url = Bundle.main.url(forResource: "ringneck-walk", withExtension: "mp4")
        
        return learnedPhrase
    }
}
