//
//  MyFlockCollectionViewCell.swift
//  Squawkie-Talkie
//
//  Created by Joe on 1/17/21.
//

import UIKit

class MyFlockCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var parrotImageView: UIImageView!
    @IBOutlet weak var parrotNameLabel: UILabel!
    
    
    var parrot: Parrot? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        if let parrot = parrot {
            guard let image = parrot.image else { return }
            guard let imageData = try? Data(contentsOf: image) else {
                return
            }
            parrotImageView.image = UIImage(data: imageData)
            parrotNameLabel.text = parrot.name
        }
    }
}
