//
//  CommentTableViewCell.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 01/08/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import UIKit
import RxSwift

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
    }

    func configureWith(comment: Comment) {
        UserService.getUser(withId: comment.authorId)
            .subscribe(onNext: { [weak self] (response: User?) in
                guard let user = response else { return }
                self?.usernameLabel.text = user.username
                self?.commentLabel.text = comment.content
                self?.dateLabel.text = comment.createdAt.fromIsoToFormattedDate(withFormat: "MMM dd,yyyy")
            }, onError: { error in
                print(error)
            })
        
    }
}
