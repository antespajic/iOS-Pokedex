//
//  RegisterViewController.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 16/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backItem?.title = ""
        
        signUpButton.setTitle("Sign Up", for: .normal)
    }

    @IBAction func signUpAction(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        UserService.register(email: email,
                             username: username,
                             password: password,
                             confirmationPassword: confirmPassword)
            .subscribe(onNext: { [weak self] response in
                //guard let user = response else { return }
                PKHUD.sharedHUD.hide()
                HUD.flash(.success, delay: 1.0)
                let homeViewController = storyboard.instantiateViewController(
                    withIdentifier: "HomeViewController"
                )
                self?.navigationController?.setViewControllers([homeViewController], animated: true)
            },
                onError: { error in
                    PKHUD.sharedHUD.hide()
                    HUD.flash(.error, delay: 1.0)
                    print(error)
            }
        ).disposed(by: disposeBag)
    }

}
