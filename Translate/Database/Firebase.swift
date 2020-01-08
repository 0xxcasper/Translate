//
//  Firebase.swift
//  RemindMe
//
//  Created by QUỐC on 6/27/19.
//  Copyright © 2019 QUỐC. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

struct Firebase {
    
    static let shared = Firebase()
    
    func signIn(_ email:String,_ pass: String,_ completion:@escaping ((Bool)->())) {
        Auth.auth().signIn(withEmail: email, password: pass) { (Result, Error) in
            if Error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func signUp(_ email:String,_ pass:String,_ name:String,_ completion:@escaping ((Bool)->())) {
        Auth.auth().createUser(withEmail: email, password: pass) { (Result, Error) in
            if (Error == nil) {
                guard let uid = Result?.user.uid else { return }
                let values = ["id":uid,"name":name,"email":email]
                let ref = Database.database().reference().child("Users").child(uid)
                ref.updateChildValues(values, withCompletionBlock: { (Error, Database) in
                    if (Error == nil) {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            AppRouter.shared.updateAppRouter()
        } catch {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func getDataUser(_ completion:@escaping ((User?)->())) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("Users").child(currentId)
        ref.observeSingleEvent(of: .value) { (DataSnapshot) in
            if let data = DataSnapshot.value as? [String:AnyObject] {
                let user = User(data)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
}
