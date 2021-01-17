//
//  PhrasesViewController.swift
//  Squawkie-Talkie
//
//  Created by Joel Groomer on 1/16/21.
//

import UIKit
import CoreData

class PhrasesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pkrStartTime: UIDatePicker!
    @IBOutlet weak var pkrEndTime: UIDatePicker!
    @IBOutlet var btnsDayOfWeek: [UIButton]!
    
    
    // MARK: - Properties
    let dataController = DataController()
    lazy var fetchedResultsController: NSFetchedResultsController<Phrase> = {
        let fetchRequest: NSFetchRequest<Phrase> = Phrase.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "text", ascending: true)
        ]
        let moc = dataController.moc
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Actions
    @IBAction func addBtnTapped(_ sender: Any) {
    }
    
    @IBAction func timeUpdated(_ sender: UIDatePicker) {
    }
    
    @IBAction func dayOfWeekBtnTapped(_ sender: UIButton) {
    }
    
    // MARK: - PhraseTableViewCell delegate
    func cellUpdated() {
        dataController.save() {
            self.tableView.reloadData()
        }
    }
    
}

extension PhrasesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // newIndexPath is option bc you'll only get it for insert and move
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
//            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
//            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            break
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension PhrasesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "phraseCell", for: indexPath) as? PhraseTableViewCell else {
            return UITableViewCell()
        }
        
        let phrase = fetchedResultsController.object(at: indexPath)
        cell.delegate = self
        cell.lblPhraseText.text = phrase.phraseText
        
        return cell
    }
    
    
}

extension PhrasesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let phrase = fetchedResultsController.object(at: indexPath)
            dataController.delete(phrase) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
