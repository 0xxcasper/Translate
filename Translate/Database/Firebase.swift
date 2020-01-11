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
    
    //MARK: - Authen
    
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
                let values = [ID:uid, NAME: name,EMAIL:email]
                let ref = Database.database().reference().child(USER).child(uid)
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
    
    func getDataUser(_ completion: @escaping ((User?)->())) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child(USER).child(currentId)
        ref.observeSingleEvent(of: .value) { (DataSnapshot) in
            if let data = DataSnapshot.value as? [String:AnyObject] {
                let user = User(data)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - Infor
    func getNumberOfAnswerRight(_ completion: @escaping ((Int)->())){
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child(INFOR).child(currentId)
        ref.observe(.value) { (DataSnapshot) in
            if let data = DataSnapshot.value as? [String:AnyObject] {
                let infor = data["numRight"] as? Int
                completion(infor ?? 0)
            } else {
                completion(0)
            }
        }
    }
    
    func updateNumberOfAnswerRight(_ number: Int) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child(INFOR).child(currentId)
        let value = ["numRight": number]
        ref.updateChildValues(value)
    }
    
    //MARK: - Topic
    
    func getAllTopic(_ completion: @escaping (([Topic])->())) {
        SVProgressHUD.show()
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child(TOPIC).child(currentId)
        ref.observe(.value) { (DataSnapshot) in
            SVProgressHUD.dismiss()
            if let data = DataSnapshot.value as? [String:AnyObject] {
                var topics = [Topic]()
                Array(data.values).forEach({ (Obj) in
                    let topic = Topic(Obj as! [String : AnyObject])
                    if !topics.contains(where: { $0.id == topic.id }) {
                        topics.append(topic)
                    }
                })
                completion(topics)
            } else {
                completion([])
            }
        }
    }
    
    func createTopic(_ title: String) {
        SVProgressHUD.show()
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child(TOPIC).child(currentId).childByAutoId()
        let value = [TITLE: title, ID: ref.key ?? kEmpty]
        ref.updateChildValues(value) { (error, data) in
            SVProgressHUD.dismiss()
            if (error != nil) {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    func createSentence(_ text: String, _ id: String, isVN: Bool = true) {
        SVProgressHUD.show()
        FirebaseTranslate.shared.translateLanguage(text: text, isVN: isVN,  completion: { (reponse) in
            let ref = Database.database().reference().child(SENTENCES).child(id).childByAutoId()
            let value = [ENGLISH: reponse, VNESE: text, ID: ref.key ?? kEmpty]
            ref.updateChildValues(value) { (error, data) in
                SVProgressHUD.dismiss()
                if (error != nil) {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        }) { (error) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func getAllSentence(_ id: String, _ completion: @escaping (([Sentence])->())) {
        SVProgressHUD.show()
        let ref = Database.database().reference().child(SENTENCES).child(id)
        ref.observe(.value) { (DataSnapshot) in
            SVProgressHUD.dismiss()
            if let data = DataSnapshot.value as? [String:AnyObject] {
                var sentences = [Sentence]()
                Array(data.values).forEach({ (Obj) in
                    let topic = Sentence(Obj as! [String : AnyObject])
                    sentences.append(topic)
                })
                completion(sentences)
            } else {
                completion([])
            }
        }
    }
    
    func getAllAnswears(_ idParent: String, _ idChild: String, _ completion: @escaping (([Sentence])->())) {
        SVProgressHUD.show()
        let ref = Database.database().reference().child(ANSWEARS).child(idParent).child(idChild)
        ref.observe(.value) { (DataSnapshot) in
            SVProgressHUD.dismiss()
            if let data = DataSnapshot.value as? [String:AnyObject] {
                var sentences = [Sentence]()
                Array(data.values).forEach({ (Obj) in
                    let topic = Sentence(Obj as! [String : AnyObject])
                    sentences.append(topic)
                })
                completion(sentences)
            } else {
                completion([])
            }
        }
    }
    
    func getAllAnswearsSpeak(_ topics: [Topic], _ completion: @escaping (([Sentence])->())) {
        var arrIdTopic = [String]()
        topics.forEach { (topic) in
            arrIdTopic.append(topic.id)
        }
        
        SVProgressHUD.show()
        let dispatchGroup = DispatchGroup()
        var sentences = [Sentence]()
        arrIdTopic.forEach { idTopic in
            dispatchGroup.enter()
            let ref = Database.database().reference().child(ANSWEARS).child(idTopic)
            ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
                dispatchGroup.leave()
                if let dataSnap = DataSnapshot.value as? [String:AnyObject]{
                    Array(dataSnap.values).forEach({ (Obj) in
                        guard let obj = Obj as? [String: AnyObject] else { return }
                        Array(obj.values).forEach({ (sentence) in
                            let topic = Sentence(sentence as! [String : AnyObject])
                            sentences.append(topic)
                        })
                    })
                    completion(sentences)
                } else {
                    completion(sentences)
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss()
        }
    }
    
    func getAllSentencesAndAnswears(_ topics: [Topic], _ completion: @escaping (([Sentence:[Sentence]])->())) {
        var arrIdTopic = [String]()
        topics.forEach { (topic) in
            arrIdTopic.append(topic.id)
        }
        
        SVProgressHUD.show()
        let dispatchGroup = DispatchGroup()
        var sentenceAnswers = [Sentence:[Sentence]]()

        arrIdTopic.forEach { idTopic in
            let ref = Database.database().reference().child(SENTENCES).child(idTopic)
            ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
                if let dataSnap = DataSnapshot.value as? [String:AnyObject] {
                    var sentences = [Sentence]()
                    Array(dataSnap.values).forEach({ (Obj) in
                        let sentence = Sentence(Obj as! [String : AnyObject])
                        sentences.append(sentence)
                    })
                    
                    sentences.forEach { sentence in
                        dispatchGroup.enter()
                        let refA = Database.database().reference().child(ANSWEARS).child(idTopic).child(sentence.id)
                        refA.observeSingleEvent(of: .value) { (Data) in
                            if let data = Data.value as? [String:AnyObject] {
                                var answers = [Sentence]()
                                Array(data.values).forEach({ (Obj) in
                                    let answer = Sentence(Obj as! [String : AnyObject])
                                    answers.append(answer)
                                })
                                if answers.count > 0 {
                                    sentenceAnswers.updateValue(answers, forKey: sentence)
                                }
                                dispatchGroup.leave()
                            } else {
                               dispatchGroup.leave()
                            }
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        completion(sentenceAnswers)
                        SVProgressHUD.dismiss()
                    }
                } else {
                    completion(sentenceAnswers)
                    SVProgressHUD.dismiss()
                }
            })
        }
        
    }
    
    
    func createAnswear(_ text: String, _ idParent: String, _ idChild: String, isVN: Bool = true) {
        SVProgressHUD.show()
        FirebaseTranslate.shared.translateLanguage(text: text, isVN: isVN,  completion: { (reponse) in
            let ref = Database.database().reference().child(ANSWEARS).child(idParent).child(idChild).childByAutoId()
            let value = [ENGLISH: reponse, VNESE: text, ID: ref.key ?? kEmpty]
            ref.updateChildValues(value) { (error, data) in
                SVProgressHUD.dismiss()
                if (error != nil) {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        }) { (error) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func deleteAnswear(_ idParent: String, _ idChild: String, _ idItem: String) {
        SVProgressHUD.show()
        let ref = Database.database().reference().child(ANSWEARS).child(idChild).child(idItem)
        ref.removeValue { error, _ in
            SVProgressHUD.dismiss()
            if (error != nil) {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    func deleteSentence(_ idParent: String, _ idChild: String) {
        SVProgressHUD.show()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        let refANSWEARS = Database.database().reference().child(ANSWEARS).child(idParent).child(idChild)
        let refSENTENCES = Database.database().reference().child(SENTENCES).child(idParent).child(idChild)
        
        refANSWEARS.removeValue { error, _ in
            dispatchGroup.leave()
            if (error != nil) {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
        
        refSENTENCES.removeValue { error, _ in
            dispatchGroup.leave()
            if (error != nil) {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss()
        }
    }
    
    func deleteTopic(_ id: String) {
        SVProgressHUD.show()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let refTOPIC = Database.database().reference().child(TOPIC).child(currentId).child(id)
        let refANSWEARS = Database.database().reference().child(ANSWEARS).child(id)
        let refSENTENCES = Database.database().reference().child(SENTENCES).child(id)
        
        refANSWEARS.removeValue { error, _ in
            dispatchGroup.leave()
            if (error != nil) {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
        
        refSENTENCES.removeValue { error, _ in
            dispatchGroup.leave()
            if (error != nil) {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
        
        refTOPIC.removeValue { error, _ in
            dispatchGroup.leave()
            if (error != nil) {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss()
        }
    }
}
