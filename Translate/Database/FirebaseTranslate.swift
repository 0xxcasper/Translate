//
//  FirebaseTranslate.swift
//  Translate
//
//  Created by Sang on 1/9/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import Firebase

struct FirebaseTranslate {
    static let shared = FirebaseTranslate()
    
    func translateLanguage(text: String, isVN : Bool, completion: @escaping (String)->Void, failure: @escaping (String)->Void) {
        let options = TranslatorOptions(sourceLanguage: isVN ? .vi : .en,  targetLanguage: isVN ? .en : .vi)
        let translator = NaturalLanguage.naturalLanguage().translator(options: options)
        
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else {
                failure(error.debugDescription)
                return
            }
            translator.translate(text) { translatedText, error in
                guard error == nil, let translatedText = translatedText else {
                    failure(error.debugDescription)
                    return
                }
                completion(translatedText)
            }
        }
    }
}
