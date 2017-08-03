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
import Kingfisher

final class PokemonDetailsViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var pokemonImage: UIImageView!
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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var pokemonId: String?
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.tableFooterView = UIView()
        
        likeButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let id = self?.pokemonId else { return }
                self?.likeButton.animateRadius()
                PokemonService.upvotePokemon(withId: id)
            })
            .disposed(by: disposeBag)
        
        dislikeButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let id = self?.pokemonId else { return }
                self?.dislikeButton.animateRadius()
                PokemonService.downvotePokemon(withId: id)
            })
            .disposed(by: disposeBag)
        
        sendButton
            .rx.tap
            .asDriver()
            .asObservable()
            .flatMap({ [weak self] _ -> Observable<Comment?> in
                guard let id = self?.pokemonId,
                    let comment = self?.commentTextField.text
                    else { return Observable.just(nil) }
                return PokemonService
                    .commentOnPokemon(withId: id, comment: comment)
            })
            .subscribe(onNext: { [weak self] (response: Comment?) in
                guard let comment = response else { return }
                self?.comments.append(comment)
                self?.commentsTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
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
                self?.genderLabel.text = String(describing: pokemon.gender.first!)
                if let imgUrl = pokemon.imageUrl {
                    let url = URL(string: APIConstants.baseURL + imgUrl)
                    self?.pokemonImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "ic-person"))
                }
            }).disposed(by: disposeBag)
        
        PokemonService.getComments(forPokemonId: id)
            .subscribe(onNext: {[weak self] (response: [Comment]) in
                self?.comments = response
                self?.commentsTableView.reloadData()
            }).disposed(by: disposeBag)
    }

}

extension PokemonDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        return comments.count
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
