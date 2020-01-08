//
//  UserSUViewModel.swift
//  RemindMe
//
//  Created by QUỐC on 7/2/19.
//  Copyright © 2019 QUỐC. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

struct UserAuth {
    
    var email:String = ""
    var password:String = ""
    var name:String = ""
}

class UserAuthViewModel {
    
    var nameString:String!
    var passString:String!
    var emailString:String!
    
    private var user = UserAuth()
    
    init() {
        nameString = user.name
        passString = user.password
        emailString = user.email
    }
    
    private func checkParamLogin() -> Bool {
        if (emailString.isEmptyOrWhitespace()) {
            SVProgressHUD.showError(withStatus: "Please enter your email")
            return false
        } else if (!emailString.isValidEmail()) {
            SVProgressHUD.showError(withStatus: "Email is not valid")
            return false
        } else if (passString.isEmptyOrWhitespace()){
            SVProgressHUD.showError(withStatus: "Please enter your password")
            return false
        }else if (passString.count < 6) {
            SVProgressHUD.showError(withStatus: "Password must have least 6 character")
            return false
        } else {
            return true
        }
    }
    
    func checkParamSignUp() -> Bool{
        if (emailString.isEmptyOrWhitespace()) {
            SVProgressHUD.showError(withStatus: "Please enter your email")
            return false
        } else if (!emailString.isValidEmail()) {
            SVProgressHUD.showError(withStatus: "Email is not valid")
            return false
        } else if (nameString.isEmptyOrWhitespace()){
            SVProgressHUD.showError(withStatus: "Please enter your name")
            return false
        } else if (passString.isEmptyOrWhitespace()){
            SVProgressHUD.showError(withStatus: "Please enter your password")
            return false
        } else if (passString.count < 6) {
            SVProgressHUD.showError(withStatus: "Password must have least 6 character")
            return false
        } else {
            return true
        }
    }
    
    func signIn(_ vc: UIViewController) {
        if self.checkParamLogin() {
            SVProgressHUD.show()
            Firebase.shared.signIn(emailString, passString) { (Bool) in
                if (Bool) {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        SVProgressHUD.dismiss()
                        AppRouter.shared.openHome()
                    }
                } else {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "Email or password is incorrect")
                }
            }
        }
    }
    
    func signUp(_ vc: UIViewController) {
        if self.checkParamSignUp() {
            SVProgressHUD.show()
            Firebase.shared.signUp(emailString, passString, nameString) { (Bool) in
                SVProgressHUD.dismiss()
                if Bool {
                    AppRouter.shared.openHome()
                } else {
                    SVProgressHUD.showError(withStatus: "Register is fail")
                }
            }
        }
    }
}
