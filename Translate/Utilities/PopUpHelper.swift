//
//  PopUpHelper.swift
//  Translate
//
//  Created by admin on 08/01/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import Foundation
import UIKit

struct PopUpHelper {

    static let shared = PopUpHelper()
    
    func showAlertWithTextField( _ vc: UIViewController,_ title: String = "",_ message: String = "", placeHolder: String = "",_ completion: @escaping (String)->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = placeHolder
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            completion(textField.text ?? "")
        }))

        vc.present(alert, animated: true, completion: nil)
    }
}
