//
//  TrainSpeakViewController.swift
//  Translate
//
//  Created by admin on 10/01/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import Speech

class TrainSpeakViewController: BaseViewController {
    
    @IBOutlet weak var lblAnwser: UILabel!
    @IBOutlet weak var txView: UITextView!
    @IBOutlet weak var btnRecord: UIButton!
    
    private var speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest      = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask         : SFSpeechRecognitionTask?
    private var audioEngine             = AVAudioEngine()
    
    private let synthesizer = AVSpeechSynthesizer()
    private var sentenceAnswers = [Sentence:[Sentence]]()
    private var sentences = [Sentence]()
    private var answers = [Sentence]()
    var noFirst: Bool = false
    private var numRight = 0
    private var currentSentence: Sentence?
    private var currentAnswer: Sentence? {
        didSet {
            self.lblAnwser.text = currentAnswer?.english
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
        self.setTitle(title: TITLE_TRAIN_SPEAK)
        btnRecord.layer.cornerRadius = 6
        self.txView.isEditable = false
        
        self.setupSpeech()
        self.getNumberOfAnswerRight()
        self.getAllSentenceAndAnswer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
    }
    
    private func getAllSentenceAndAnswer() {
        Firebase.shared.getAllSentencesAndAnswears(topic) { (sentenceAnswers) in
            self.sentenceAnswers = sentenceAnswers
            self.sentences = Array(sentenceAnswers.keys)
            if self.sentences.count > 0 {
                self.currentIndexSentence = 0
                self.answers = self.sentenceAnswers[self.currentSentence!]!
                self.currentIndexAnswer = 0
                self.btnRecord.isEnabled = true
            } else {
                self.btnRecord.isEnabled = false
            }
        }
    }
    
    private func getNumberOfAnswerRight() {
        Firebase.shared.getNumberOfAnswerRight { (num) in
            self.numRight = num
        }
    }
    
    private func setupSpeech() {
        self.btnRecord.isEnabled = false
        self.speechRecognizer?.delegate = self

        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                SVProgressHUD.showError(withStatus:"User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                SVProgressHUD.showError(withStatus: "Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                SVProgressHUD.showError(withStatus:"Speech recognition not yet authorized")
            @unknown default:
                SVProgressHUD.showError(withStatus: "Speech recognition not yet authorized")
            }
            OperationQueue.main.addOperation() {
                self.btnRecord.isEnabled = isButtonEnabled
            }
        }
    }
    
    private func startRecording() {
        self.configRecord()
        let inputNode = self.audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest.append(buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.txView.text = "Say something, I'm listening!"
        
        
        self.recognitionRequest.shouldReportPartialResults = true

        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        self.recognitionTask = speechRecognizer?.recognitionTask(with: self.recognitionRequest, resultHandler: { (result, error) in
            if result != nil {
                self.txView.text = result?.bestTranscription.formattedString
                if let text = self.txView.text {
                    let result: ComparisonResult = text.compare(self.currentAnswer?.english ?? "", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                    if result == .orderedSame {
                        SVProgressHUD.showError(withStatus: "Kết quả chính xác, bạn vui lòng nghe câu tiếp theo")
                        self.txView.text = ""
                        self.nextAnswer()
                    }
                }
            }
            if error != nil {
                self.stopRecord()
            }
        })
    }
    
    private func nextAnswer() {
        if self.answers.count - 1 > self.currentIndexAnswer {
            self.currentIndexAnswer += 1
            self.stopRecord()
        } else {
            if self.currentIndexSentence < self.sentences.count - 1 {
                self.currentIndexSentence += 1
                self.answers = self.sentenceAnswers[self.currentSentence!]!
                self.currentIndexAnswer = 0
            } else {
                SVProgressHUD.showSuccess(withStatus: "Bạn đã hoàn thành bài luyện nói")
                Firebase.shared.updateNumberOfAnswerRight(self.numRight + 1)
                self.btnRecord.isEnabled = false
            }
        }
        Firebase.shared.updateNumberOfAnswerRight(self.numRight + 1)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopRecord()
    }
}

// MARK: - Action's Methods

extension TrainSpeakViewController {
    
    @IBAction func didTapStartPlayOrPauseRecord(_ sender: UIButton) {
        //nextAnswer()
        if audioEngine.isRunning {
            self.stopRecord()
            self.checkResult()
        } else {
            self.startRecording()
            self.btnRecord.setTitle("Stop Recording", for: .normal)
        }
    }
    
    private func stopRecord() {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionTask?.cancel()
            self.btnRecord.isEnabled = true
            self.txView.text = ""
            self.btnRecord.setTitle("Start Recording", for: .normal)
        }
    }
    
    private func checkResult() {
        if(self.txView.text != self.currentAnswer?.english ?? "") {
            SVProgressHUD.showError(withStatus: "Kết quả sai")
        }
    }
    
    @IBAction func didTapPlaySentences(_ sender: UIButton) {
        if let currentSentence = self.currentSentence {
            let utterance = currentSentence.english.configAVSpeechUtterance()
            synthesizer.speak(utterance)
            self.configSpeech()
        }
    }
    
    @IBAction func didTapPlaySoundAnswer(_ sender: UIButton) {
        if let currentAnswer = self.currentAnswer {
            let utterance = currentAnswer.english.configAVSpeechUtterance()
            synthesizer.speak(utterance)
            self.configSpeech()
        }
    }
    
    private func configSpeech() {
        do{
            let _ = try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        }catch{
            print(error)
        }
    }
    
    private func configRecord() {
        do{
            let _ = try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.duckOthers)
        } catch {
            print(error)
        }
    }
}

// MARK: - SFSpeechRecognizerDelegate Methods

extension TrainSpeakViewController: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.btnRecord.isEnabled = true
        } else {
            self.btnRecord.isEnabled = false
        }
    }
}
