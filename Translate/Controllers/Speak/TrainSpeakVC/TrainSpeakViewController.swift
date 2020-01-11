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
    
    private let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask         : SFSpeechRecognitionTask?
    private var audioEngine             = AVAudioEngine()
    
    private let synthesizer = AVSpeechSynthesizer()
    private var sentenceAnswers = [Sentence:[Sentence]]()
    private var sentences = [Sentence]()
    private var answers = [Sentence]()
    
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
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true

        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if result != nil {
                self.txView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.btnRecord.isEnabled = true
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.txView.text = "Say something, I'm listening!"
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
                SVProgressHUD.showSuccess(withStatus: "Bạn đã hoàn thành bài luyện nói")
                Firebase.shared.updateNumberOfAnswerRight(self.numRight + 1)
                self.btnRecord.isEnabled = false
            }
        }
        Firebase.shared.updateNumberOfAnswerRight(self.numRight + 1)
    }
}

// MARK: - Action's Methods

extension TrainSpeakViewController
{
    @IBAction func didTapStartPlayOrPauseRecord(_ sender: UIButton) {
        nextAnswer()
//        if audioEngine.isRunning {
//            self.audioEngine.stop()
//            self.recognitionRequest?.endAudio()
//            self.audioEngine.inputNode.removeTap(onBus: 0)
//            self.btnRecord.setTitle("Start Recording", for: .normal)
//        } else {
//            self.startRecording()
//            self.btnRecord.setTitle("Stop Recording", for: .normal)
//        }
    }
    
    @IBAction func didTapPlaySentences(_ sender: UIButton) {
        if let currentSentence = self.currentSentence {
            let utterance = currentSentence.english.configAVSpeechUtterance()
            synthesizer.speak(utterance)
        }
    }
    
    @IBAction func didTapPlaySoundAnswer(_ sender: UIButton) {
        if let currentAnswer = self.currentAnswer {
            let utterance = currentAnswer.english.configAVSpeechUtterance()
            synthesizer.speak(utterance)
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
