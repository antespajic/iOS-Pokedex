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

class HomeViewController: UIViewController, Progressable {

    let disposeBag = DisposeBag()
    
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
        
    }
    
    @objc func createPokemon() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let createPokemonViewController = storyboard.instantiateViewController(
            withIdentifier: "CreatePokemonVC"
        )
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let poke = pokemons[indexPath.row]
        cell.pokemonName.text = poke.name
        
        return cell
    }
    
}


