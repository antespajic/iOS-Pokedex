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
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton
            .rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard
                    let username = self?.userNameTextField.text,
                    let password = self?.passwordTextField.text,
                    !username.isEmpty, !password.isEmpty
                    else { return }
                self?.loginButton.animatePulse()
                self?.showLoading()
                
                self?.login(username: username, password: password, saveCredentials: true)
                
            }).disposed(by: disposeBag)
        
        signUpButton
            .rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.signUpButton.animatePulse()
                self?.showLoading()
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
        
        if let email = UserDefaults.standard.value(forKey: "email") as? String,
            let password = UserDefaults.standard.value(forKey: "password") as? String {
            login(username: email, password: password, saveCredentials: false)
        }
    }
    
    func login(username: String, password: String, saveCredentials: Bool) {
        SessionService
            .login(email: username, password: password)
            .subscribe(
                onNext: { [weak self] response in
                    self?.hideLoading()
                    guard let user = response else { return }
                    if (saveCredentials) {
                        UserDefaults.standard.setValue(username, forKey: "email")
                        UserDefaults.standard.setValue(password, forKey: "password")
                    }
                    
                    UserSession.sharedInstance.createAuthHeader(authToken: user.authToken, email: user.email)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    let homeViewController = storyboard.instantiateViewController(
                        withIdentifier: "HomeViewController"
                        ) as! HomeViewController
                    homeViewController.user = user
                    self?.navigationController?.setViewControllers([homeViewController], animated: true)
                },
                onError: { [weak self] _ in
                    self?.hideLoading()
                    let alert = UIAlertController(title: "Oops!", message: "Something went wrong, check your email and password and try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            ).disposed(by: disposeBag)
        
        
    }
    
    // set button styles and labels
    func setupView() {
        loginButton.setTitle("Log In", for: .normal)
        signUpButton.setTitle("Sign Up", for: .normal)

        registerKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    

}
