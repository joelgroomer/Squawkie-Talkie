//
//  PhraseTableViewCell.swift
//  Squawkie-Talkie
//
//  Created by Joel Groomer on 1/16/21.
//

import UIKit

class PhraseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnToggleActive: UIButton!
    @IBOutlet weak var lblPhraseText: UILabel!
    @IBOutlet weak var btnLearned: UIButton!
    
    var delegate: PhrasesViewController?
    var phrase: Phrase?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        let image = phrase?.active ?? false ? UIImage(systemName: "quote.bubble") : UIImage(systemName: "speaker.slash")
        btnToggleActive.setImage(image, for: .normal)
    }

    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */

    
    @IBAction func toggleActive(_ sender: Any) {
        phrase?.active.toggle()
        updateViews()
        delegate?.cellUpdated()
    }
    
    @IBAction func learnedBtnTapped(_ sender: Any) {
        // TODO: Segue to a screen to choose which bird learned the phrase
        // and offer a chance to record them saying it
    }
    
}
