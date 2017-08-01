//
//  PokemonDetailsViewController.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 31/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class PokemonDetailsViewController: UIViewController {

    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonDescLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    private let disposeBag = DisposeBag()
    var pokemonId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let id = pokemonId else { return }
        PokemonService.getPokemon(withId: id)
            .subscribe(onNext: { [weak self] response in
                guard let pokemon = response else { return }
                
            }).disposed(by: disposeBag)
    }

}
