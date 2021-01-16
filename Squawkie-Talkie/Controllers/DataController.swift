//
//  DataController.swift
//  Squawkie-Talkie
//
//  Created by Joel Groomer on 1/16/21.
//

import CoreData

class DataController {
    let container: NSPersistentContainer
    let moc: NSManagedObjectContext
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Squawkie_Talkie")
        
        if inMemory {
            // Write data to null so that it only persists for one session
            // This is useful for testing purposes
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
        
        moc = container.viewContext
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let phrase = Phrase(context: viewContext)
            phrase.active = true
            phrase.text = "Test phrase \(i)"
        }
    }
}
