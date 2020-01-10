//
//  InfoVC.swift
//  Translate
//
//  Created by Sang on 1/8/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit

class InfoVC: BaseViewController {
    
    @IBOutlet weak var lblNumTopic: UILabel!
    @IBOutlet weak var lblNumSentence: UILabel!
    @IBOutlet weak var lblNumRight: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle(title: "THÔNG TIN")
        
        Firebase.shared.getAllTopic { (topics) in
            self.lblNumTopic.text = "Tổng số chủ đề: \(topics.count)"
            Firebase.shared.getAllAnswearsSpeak(topics) { (sentences) in
                self.lblNumSentence.text = "Tổng số câu thoại: \(sentences.count)"
            }
        }
        
        Firebase.shared.getNumberOfAnswerRight { (num) in
            self.lblNumRight.text = "Số câu đã thực hành đúng: \(num)"
        }
    }

    @IBAction func didTapSignOut(_ sender: UIButton) {
        Firebase.shared.signOut()
    }

}
