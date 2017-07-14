//
//  LoginViewController.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 06/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set button styles and labels
        loginButton.setTitle("Log In", for: UIControlState.normal)
        signUpButton.setTitle("Sign Up", for: UIControlState.normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        guard
            let username = userNameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty, !password.isEmpty
            else { return }
        
        print(username + " " + password)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
