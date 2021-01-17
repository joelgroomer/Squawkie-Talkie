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
        
        for i in 1...5 {
            let parrot = Parrot(context: viewContext)
            parrot.breed = "Test breed"
            parrot.name = "Test parrot \(i)"
        }
        
        try viewContext.save()
    }
    
    func save(completion: (() -> Void)?) {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
        
        if let completion = completion {
            completion()
        }
    }
    
    func delete(_ object: NSManagedObject, completion: (() -> Void)?) {
        container.viewContext.delete(object)
        if let completion = completion {
            completion()
        }
    }
    
    func deleteAll() {
        // delete all LearnedPhrases
        let fetchRequestLearnedPhrases: NSFetchRequest<NSFetchRequestResult> = LearnedPhrase.fetchRequest()
        let batchDeleteRequestLearnedPhrases = NSBatchDeleteRequest(fetchRequest: fetchRequestLearnedPhrases)
        _ = try? container.viewContext.execute(batchDeleteRequestLearnedPhrases)
        
        // delete all Parrots
        let fetchRequestParrots: NSFetchRequest<NSFetchRequestResult> = Parrot.fetchRequest()
        let batchDeleteRequestParrots = NSBatchDeleteRequest(fetchRequest: fetchRequestParrots)
        _ = try? container.viewContext.execute(batchDeleteRequestParrots)
        
        // delete all Phrases
        let fetchRequestPhrases: NSFetchRequest<NSFetchRequestResult> = Phrase.fetchRequest()
        let batchDeleteRequestPhrases = NSBatchDeleteRequest(fetchRequest: fetchRequestPhrases)
        _ = try? container.viewContext.execute(batchDeleteRequestPhrases)
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        // returns the number of T items returned by a fetch request
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
}
