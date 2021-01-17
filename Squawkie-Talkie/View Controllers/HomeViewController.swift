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
    
    let parrots: [Parrots]
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Parrot> = {
        let fetchRequest: NSFetchRequest<Movies> = Movies.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: moc,
            sectionNameKeyPath: "hasWatched",
            cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        tipsTableView.dataSource = self
        tipsTableView.delegate = self
    }
    

//     MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParrotNames", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toParrot", sender: self)
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
            tipsTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tipsTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default: break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tipsTableView.insertRows(at: [newIndexPath], with: .automatic)
            newsTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tipsTableView.reloadRows(at: [indexPath], with: .automatic)
            newsTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexpath = indexPath, let newIndexPath = newIndexPath else { return }
            tipsTableView.deleteRows(at: [oldIndexpath], with: .automatic)
            newsTableView.deleteRows(at: [oldIndexpath], with: .automatic)
            tipsTableView.insertRows(at: [newIndexPath], with: .automatic)
            newsTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tipsTableView.deleteRows(at: [indexPath], with: .automatic)
            newsTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default: break
        }
    }
}
