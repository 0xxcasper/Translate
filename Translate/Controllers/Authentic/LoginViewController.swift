//
//  LoginViewController.swift
//  RemindMe
//
//  Created by QUỐC on 6/23/19.
//  Copyright © 2019 QUỐC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    private var viewModel = UserAuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView(){
        btnLogin.layer.cornerRadius = 20
        btnLogin.clipsToBounds = true
        
        txfEmail.delegate = self
        txfPassword.delegate = self
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        txfPassword.resignFirstResponder()
        viewModel.signIn(self)
    }
    
    @IBAction func handleGotoRegister(_ sender: UIButton) {
        let registerVC = RegisterViewController()
        self.present(registerVC, animated: true, completion: nil)
    }
}

extension LoginViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == txfEmail {
            viewModel.emailString = txfEmail.text!
        } else {
            viewModel.passString = txfPassword.text!
        }
        return true
    }
}
