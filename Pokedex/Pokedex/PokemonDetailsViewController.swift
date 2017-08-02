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

    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonDescLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView! {
        didSet {
            commentsTableView.delegate = self
            commentsTableView.dataSource = self
        }
    }
    
    var pokemonId: String?
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let id = pokemonId else { return }
        PokemonService.getPokemon(withId: id)
            .subscribe(onNext: { [weak self] (response: Pokemon?) in
                guard let pokemon = response else { return }
                self?.pokemonNameLabel.text = pokemon.name
                self?.pokemonDescLabel.text = pokemon.description
                self?.heightLabel.text = String(format:"%.1f", pokemon.height)
                self?.weightLabel.text = String(format:"%.1f", pokemon.weight)
                self?.typeLabel.text = pokemon.type
                self?.genderLabel.text = pokemon.gender
            }).disposed(by: disposeBag)
        
        PokemonService.getComments(forPokemonId: id)
            .subscribe(onNext: {[weak self] (response: [Comment]) in
                self?.comments = response
            }).disposed(by: disposeBag)
    }

}

extension PokemonDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

extension PokemonDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
         Number of rows in each section
         */
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "PokemonCommentCell",
            for: indexPath
            ) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        cell.configureWith(comment: comment)
        
        return cell
    }
    
}
