//
//  HomeViewController.swift
//  Squawkie-Talkie
//
//  Created by Joe on 1/16/21.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var tipsTableView: UITableView!

    
    private let dataController = DataController()
 
    private lazy var fetchedResultsController: NSFetchedResultsController<Parrot> = {
        let fetchRequest: NSFetchRequest<Parrot> = Parrot.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let moc = dataController.moc
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: moc,
            sectionNameKeyPath: "name",
            cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    private lazy var fetchedResultsController2: NSFetchedResultsController<Phrase> = {
        let fetchRequest: NSFetchRequest<Phrase> = Phrase.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "text", ascending: true)
        ]
        let moc = dataController.moc
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: moc,
            sectionNameKeyPath: "text",
            cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "MMMM dd YYYY"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        tipsTableView.dataSource = self
        tipsTableView.delegate = self
    }
    
    @IBAction func sampleDataButtonTapped(_ sender: UIButton) {
        do {
            try dataController.createSampleData()
            
                    let fetchRequest: NSFetchRequest<Parrot> = Parrot.fetchRequest()
                    fetchRequest.sortDescriptors = [
                        NSSortDescriptor(key: "name", ascending: true)
                    ]
                    let moc = dataController.moc
                    let frc = NSFetchedResultsController(
                        fetchRequest: fetchRequest,
                        managedObjectContext: moc,
                        sectionNameKeyPath: "name",
                        cacheName: nil)
                    frc.delegate = self
                    try? frc.performFetch()
              
        } catch {
            print("There was an error: \(error)")
        }
    }
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == newsTableView {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "ParrotNames", for: indexPath)
        let parrots = fetchedResultsController.object(at: indexPath)
        let date = dateFormatter.string(from: parrots.hatchDate ?? Date(timeIntervalSince1970: 00.0))
        cell.textLabel?.text = parrots.name
        cell.detailTextLabel?.text = date
            return cell
        } else {
        let phrase = tipsTableView.dequeueReusableCell(withIdentifier: "Phrases", for: indexPath)
        let phrases = fetchedResultsController2.object(at: indexPath)
        phrase.textLabel?.text = phrases.text
        
        return phrase
        }
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsTableView.beginUpdates()
        tipsTableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsTableView.endUpdates()
        tipsTableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            newsTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
            tipsTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            newsTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
            tipsTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default: break
        }
    }
}
