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
}
