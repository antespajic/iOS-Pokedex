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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // set button styles and labels
    func setupView() {
        loginButton.setTitle("Log In", for: .normal)
        signUpButton.setTitle("Sign Up", for: .normal)
        
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) { [weak self] in
            PKHUD.sharedHUD.hide()
            let signUpViewController = storyboard.instantiateViewController(
                withIdentifier: "SignUpViewController"
            )
            self?.navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        guard
            let username = userNameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty, !password.isEmpty
            else { return }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        SessionService
            .login(email: username, password: password)
            .subscribe(
                onNext: { [weak self] response in
                    PKHUD.sharedHUD.hide()
                    guard let user = response else {
                        return
                    }
                    let homeViewController = storyboard.instantiateViewController(
                        withIdentifier: "HomeViewController"
                    )
                    self?.navigationController?.setViewControllers([homeViewController], animated: true)
                    print (user)
                }
        ).disposed(by: disposeBag)
        
    }

}
