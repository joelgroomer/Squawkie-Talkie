//
//  ParrotDetailViewController.swift
//  Squawkie-Talkie
//
//  Created by Joe on 1/17/21.
//

import UIKit

class ParrotDetailViewController: UIViewController {
    
    @IBOutlet weak var parrotImageView: UIImageView!
    @IBOutlet weak var parrotNameLabel: UILabel!
    @IBOutlet weak var hatchDateField: UITextField!
    @IBOutlet weak var gotchDateField: UITextField!
    @IBOutlet weak var breedField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var parrot: Parrot?
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "MMMM dd YYYY"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        if let parrot = parrot {
            guard let image = parrot.image else { return }
            guard let imageData = try? Data(contentsOf: image) else {
              return
            }
            parrotImageView.image = UIImage(data: imageData)
            parrotNameLabel.text = parrot.name
            hatchDateField.text = dateFormatter.string(from: parrot.hatchDate!)
            gotchDateField.text = dateFormatter.string(from: parrot.gotchaDate!)
            breedField.text = parrot.breed
            
        }
    }
}

extension ParrotDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parrot?.phrasesLearned?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhrasesCell", for: indexPath)
        if let parrot = parrot {
            cell.textLabel?.text = parrot.name
        }
        return cell
    }
    
    
}
