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
import RxCocoa

class SignUpViewController: UIViewController, Progressable {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton
            .rx.tap
            .asDriver()
            .drive(onNext: { _ in
                guard let email = self.emailTextField.text,
                    let username = self.usernameTextField.text,
                    let password = self.passwordTextField.text,
                    let confirmPassword = self.confirmPasswordTextField.text else { return }
                
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                self.showLoading()
                
                UserService.register(email: email,
                                     username: username,
                                     password: password,
                                     confirmationPassword: confirmPassword)
                    .subscribe(onNext: { [weak self] response in
                        //guard let user = response else { return }
                        self?.showSuccess()
                        let homeViewController = storyboard.instantiateViewController(
                            withIdentifier: "HomeViewController"
                        )
                        self?.navigationController?.setViewControllers([homeViewController], animated: true)
                        },
                               onError: { [weak self] error in
                                self?.showError()
                                print(error)
                        }
                    ).disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backItem?.title = ""
        
        signUpButton.setTitle("Sign Up", for: .normal)
    }

}
