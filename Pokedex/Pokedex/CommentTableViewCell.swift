//
//  CommentTableViewCell.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 01/08/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import UIKit

final class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
