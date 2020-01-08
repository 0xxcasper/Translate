//
//  RegisterViewController.swift
//  RemindMe
//
//  Created by QUỐC on 6/25/19.
//  Copyright © 2019 QUỐC. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    private var viewModel = UserAuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    private func setUpView(){
        btnSignUp.layer.cornerRadius = 20
        btnSignUp.clipsToBounds = true
        
        txfEmail.delegate = self
        txfName.delegate = self
        txfPassword.delegate = self
    }
    
    @IBAction func handleSignUp(_ sender: UIButton) {
        txfPassword.resignFirstResponder()
        viewModel.signUp(self)
    }
    
    @IBAction func handleBackToLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == txfName {
            viewModel.nameString = txfName.text!
        } else if (textField == txfEmail) {
            viewModel.emailString = txfEmail.text!
        } else {
            viewModel.passString = txfPassword.text!
        }
        return true
    }
}
