//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 25/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import UIKit
import Kingfisher

class PokemonTableViewCell: UITableViewCell {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    var pokemonId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        // You want to clear up image view here ...
        super.prepareForReuse()
        pokemonImage.image = nil
        pokemonName.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(pokemon: Pokemon) {
        pokemonId = pokemon.id
        pokemonName.text = pokemon.name
        pokemonName.textColor = UIColor.darkGray
        
        pokemonImage.layer.cornerRadius = pokemonImage.frame.size.width / 2
        pokemonImage.clipsToBounds = true
        pokemonImage.layer.borderWidth = 1
        pokemonImage.layer.borderColor = UIColor.lightGray.cgColor
        
        if let imgUrl = pokemon.imageUrl {
            let url = URL(string: APIConstants.baseURL + imgUrl)
            pokemonImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "ic-person"))
        }
    }
}
