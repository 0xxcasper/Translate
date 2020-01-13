//
//  TrainListenViewController.swift
//  Translate
//
//  Created by admin on 11/01/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class TrainListenViewController: BaseViewController {
    
    @IBOutlet weak var lblSentence: UILabel!
    @IBOutlet weak var txfAnwser: UITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    private let synthesizer = AVSpeechSynthesizer()
    private var sentenceAnswers = [Sentence:[Sentence]]()
    private var sentences = [Sentence]()
    private var answers = [Sentence]()
    
    private var numRight = 0
    private var currentSentence: Sentence?{
        didSet {
            self.lblSentence.text = currentSentence?.english
        }
    }
    private var currentAnswer: Sentence? {
        didSet {
            self.lblResult.text = self.currentAnswer?.english
        }
    }
    private var currentIndexAnswer = 0 {
        didSet {
            self.currentAnswer = self.answers[currentIndexAnswer]
        }
    }
    private var currentIndexSentence = 0 {
        didSet {
            self.currentSentence = self.sentences[currentIndexSentence]
        }
    }
    var topic: [Topic]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setTitle(title: TITLE_TRAIN_LISTEN)
        self.getNumberOfAnswerRight()
        self.getAllSentenceAndAnswer()
    }
    
    private func setupView() {
        btnCheck.layer.cornerRadius = 6
        lblResult.isHidden = true
        containerView.addShadowBottom()
    }
    
    private func getNumberOfAnswerRight() {
        Firebase.shared.getNumberOfAnswerRight { (num) in
            self.numRight = num
        }
    }
    
    private func getAllSentenceAndAnswer() {
        Firebase.shared.getAllSentencesAndAnswears(topic) { (sentenceAnswers) in
            self.sentenceAnswers = sentenceAnswers
            self.sentences = Array(sentenceAnswers.keys)
            if self.sentences.count > 0 {
                self.currentIndexSentence = 0
                self.answers = self.sentenceAnswers[self.currentSentence!]!
                self.currentIndexAnswer = 0
                self.btnCheck.isEnabled = true
            } else {
                self.btnCheck.isEnabled = false
            }
        }
    }
    
    private func nextAnswer() {
        if self.answers.count - 1 > self.currentIndexAnswer {
            self.currentIndexAnswer += 1
        } else {
            if self.currentIndexSentence < self.sentences.count - 1 {
                self.currentIndexSentence += 1
                self.answers = self.sentenceAnswers[self.currentSentence!]!
                self.currentIndexAnswer = 0
            } else {
                SVProgressHUD.showSuccess(withStatus: "Bạn đã hoàn thành bài luyện nghe")
                Firebase.shared.updateNumberOfAnswerRight(self.numRight + 1)
                self.btnCheck.isEnabled = false
            }
        }
        Firebase.shared.updateNumberOfAnswerRight(self.numRight + 1)
    }
    

    @IBAction func didTapCheck(_ sender: Any) {
        if let text = self.txfAnwser.text {
            let result: ComparisonResult = text.compare(self.currentAnswer?.english ?? "", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            if result == .orderedSame {
                SVProgressHUD.showSuccess(withStatus: "Kết quả chính xác, bạn vui lòng nhập câu tiếp theo.")
                self.txfAnwser.text = ""
                self.nextAnswer()
            } else {
                SVProgressHUD.showError(withStatus: "Kết quả thì sai")
            }
        }
    }
    
    @IBAction func didTapPlaySentence(_ sender: Any) {
        if let currentSentence = self.currentSentence {
            let utterance = currentSentence.english.configAVSpeechUtterance()
            synthesizer.speak(utterance)
        }
    }
    
    @IBAction func didTapPlayAnser(_ sender: Any) {
        if let currentAnswer = self.currentAnswer {
            let utterance = currentAnswer.english.configAVSpeechUtterance()
            synthesizer.speak(utterance)
        }
    }
    
    @IBAction func onTapShowResult(_ sender: Any) {
        lblResult.isHidden = !lblResult.isHidden
    }
}
