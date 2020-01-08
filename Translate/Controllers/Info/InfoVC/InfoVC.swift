//
//  InfoVC.swift
//  Translate
//
//  Created by Sang on 1/8/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapSignOut(_ sender: UIButton) {
        Firebase.shared.signOut()
    }

}
