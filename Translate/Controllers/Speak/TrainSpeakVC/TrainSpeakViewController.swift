//
//  TrainSpeakViewController.swift
//  Translate
//
//  Created by admin on 10/01/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit

class TrainSpeakViewController: BaseViewController {
    
    @IBOutlet weak var lblAnwser: UILabel!
    
    var topics: [Topic]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(title: TITLE_TRAIN_SPEAK)
    }


    @IBAction func didTapPlaySoundAnswer(_ sender: UIButton) {
        
    }

}
