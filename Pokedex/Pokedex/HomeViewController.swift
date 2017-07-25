//
//  HomeViewController.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 18/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var user: User?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PokemonService.getAll()
            .subscribe(
                onNext: { [weak self] response in
                    self?.pokemons.append(contentsOf: response)
                },
                onError: { error in
                    print("E jebiga")
                }
            ).disposed(by: disposeBag)
    }
    
}


extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
         Number of rows in each section
         */
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PokemonTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "PokemonTableViewCell",
            for: indexPath
        ) as! PokemonTableViewCell
        let poke = pokemons[0]
        
        cell.pokemonName.text = poke.name
        
        return cell
    }
    
}


