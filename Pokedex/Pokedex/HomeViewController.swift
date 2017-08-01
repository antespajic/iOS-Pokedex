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
import Kingfisher

class HomeViewController: UIViewController, Progressable {

    private let disposeBag = DisposeBag()
    
    var user: User?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.topItem?.title = "Pokedex"
        navigationController?.navigationBar.backItem?.title = ""
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic-logout"),
            style: .plain,
            target: self,
            action: #selector(logout)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic-plus"),
            style: .plain,
            target: self,
            action: #selector(createPokemon)
        )
        
        showLoading()
        PokemonService.getAll()
            .subscribe(
                onNext: { [weak self] response in
                    self?.pokemons = response
                    self?.hideLoading()
                    self?.tableView.reloadData()
                }
            ).disposed(by: disposeBag)
    }
    
    func addNewPokemon(_ pokemon: Pokemon) {
        pokemons.append(pokemon)
        tableView.reloadData()
    }
    
    @objc func createPokemon() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let createPokemonViewController = storyboard.instantiateViewController(
            withIdentifier: "CreatePokemonVC"
        ) as! CreatePokemonViewController
        createPokemonViewController.delegate = self
        self.navigationController?.pushViewController(createPokemonViewController, animated: true)
    }
    
    @objc func logout() {
        SessionService
            .logout()
            .subscribe( onNext: { [weak self] result in
                switch result {
                case .success:
                    UserSession.sharedInstance.clearAuthHeader()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    let loginViewController = storyboard.instantiateViewController(
                            withIdentifier: "LoginViewController"
                        )
                    
                    self?.navigationController?.setViewControllers([loginViewController], animated: true)
                    
                case .failure:
                    print("No internet connection?")
                }
            }).disposed(by: disposeBag)
    }
    
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: PokemonTableViewCell = tableView.cellForRow(at: indexPath) as! PokemonTableViewCell
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let detailsViewController = storyboard.instantiateViewController(
            withIdentifier: "PokemonDetailsVC"
        ) as! PokemonDetailsViewController
        
        detailsViewController.pokemonId = cell.pokemonId
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let pokemonCell = cell as? PokemonTableViewCell
        pokemonCell?.pokemonImage.kf.cancelDownloadTask()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
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
        let poke = pokemons[indexPath.row]
        cell.configureWith(pokemon: poke)
        
        return cell
    }
    
}


