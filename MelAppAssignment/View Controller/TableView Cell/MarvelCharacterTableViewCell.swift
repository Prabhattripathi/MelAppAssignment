//
//  MarvelCharacterTableViewCell.swift
//  MelAppAssignment
//
//  Created by Prabhat on 10/12/20.
//  Copyright © 2020 prabhat. All rights reserved.
//

import UIKit

class MarvelCharacterTableViewCell: UITableViewCell {

  @IBOutlet weak var characterImageView: UIImageView! {
    didSet {
      characterImageView.layer.borderWidth = 1.5
      characterImageView.layer.borderColor = UIColor.rgb(r: 41, g: 41, b: 92).cgColor
      //characterImageView.layer.cornerRadius = characterImageView.frame.size.height / 2
    }
  }
  @IBOutlet weak var characterNamelabel: UILabel!
  @IBOutlet weak var characterDescriptionLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
