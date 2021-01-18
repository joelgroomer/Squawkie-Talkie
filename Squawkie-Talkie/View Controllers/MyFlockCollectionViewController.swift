//
//  MyFlockCollectionViewController.swift
//  Squawkie-Talkie
//
//  Created by Joe on 1/17/21.
//
import CoreData
import UIKit

private let reuseIdentifier = "MyFlockCell"

class MyFlockCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    let dataController = DataController()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetail" {
            if let indexPath = sender as? IndexPath, let vc = segue.destination as? ParrotDetailViewController {
                vc.parrot = fetchedResultsController.object(at: indexPath)
            }
        }
    }
   

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    // FIXME: Getting an error stating there's no reuseIdentifier
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? MyFlockCollectionViewCell else { return UICollectionViewCell() }
        let parrots = fetchedResultsController.object(at: indexPath)
        cell.parrot = parrots
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDetail", sender: indexPath)
    }

}
