//
//  LoginViewController.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 06/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, Progressable {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton
            .rx.tap
            .asDriver()
            .drive(onNext: { _ in
                guard
                    let username = self.userNameTextField.text,
                    let password = self.passwordTextField.text,
                    !username.isEmpty, !password.isEmpty
                    else { return }
                
                self.showLoading()
                
                self.login(username: username, password: password)
                
            }).disposed(by: disposeBag)
        
        signUpButton
            .rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.showLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) { [weak self] in
                    self?.hideLoading()
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    let signUpViewController = storyboard.instantiateViewController(
                        withIdentifier: "SignUpViewController"
                    )
                    self?.navigationController?.pushViewController(signUpViewController, animated: true)
                }
            }).disposed(by: disposeBag)
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func login(username: String, password: String) {
        SessionService
            .login(email: username, password: password)
            .subscribe(
                onNext: { [weak self] response in
                    self?.hideLoading()
                    guard let user = response else { return }
                    
                    UserSession.sharedInstance.createAuthHeader(authToken: user.authToken, email: user.email)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    let homeViewController = storyboard.instantiateViewController(
                        withIdentifier: "HomeViewController"
                        ) as! HomeViewController
                    homeViewController.user = user
                    self?.navigationController?.setViewControllers([homeViewController], animated: true)
                }
            ).disposed(by: disposeBag)
    }
    
    // set button styles and labels
    func setupView() {
        loginButton.setTitle("Log In", for: .normal)
        signUpButton.setTitle("Sign Up", for: .normal)
        
    }

}
