//
//  ListAnswearVC.swift
//  Translate
//
//  Created by Sang on 1/9/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit
import AVFoundation

class ListAnswearVC: BaseTableViewController {

    lazy var sentence: Sentence! = nil
    lazy var topic: Topic! = nil

    private let synthesizer = AVSpeechSynthesizer()
    private var previousIndex: IndexPath?
    private var currentIndex: IndexPath?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imvSpeak: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        self.setTitle(title: TITLE_LIST_QUETION)
        guard let vnese = sentence.vnese, let english = sentence.english else { return }
        lblTitle.text = vnese
        lblDetail.text = english
        
        synthesizer.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imvSpeak.isUserInteractionEnabled = true
        imvSpeak.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.makeSpeak(self.sentence.english)
    }
    
    func makeSpeak(_ text: String) {
        let utterance = text.configAVSpeechUtterance()
        if(synthesizer.isSpeaking && previousIndex != nil) {
            guard let cell = myTableView.cellForRow(at: previousIndex!) as? AnswearCell else { return }
            cell.isPlay = false
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        synthesizer.speak(utterance)
    }
    
    private func stopSpeak() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        previousIndex = nil
    }
    
    override func registerCell() {
        super.registerCell()
        myTableView.registerXibFile(AnswearCell.self)
    }
    
    override func fetchData() {
        super.fetchData()
        Firebase.shared.getAllAnswears(topic.id, sentence.id, { (reponse) in
            guard let sentences = reponse else { return }
            self.didFetchData(data: sentences)
        })
    }
    
    override func cellForRowAt(item: Any, for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeue(AnswearCell.self, for: indexPath)
        cell.setupCell(indexPath, item: item as! Sentence)
        cell.delegate = self
        return cell
    }
    
    override func editCell(item: Any, indexPath: IndexPath, type: UITableViewCell.EditingStyle) {
        if (type == .delete) {
            Firebase.shared.deleteAnswear(self.topic.id, self.sentence.id, (item as! Sentence).id)
        }
    }
    
    @IBAction func actAddNewSentence(_ sender: Any) {
        PopUpHelper.shared.showAlertWithTextField(self, kNewSentence, kImportDetailSentence) { (text) in
            Firebase.shared.createAnswear(text, self.topic.id, self.sentence.id, isVN: true)
        }
    }
}

extension ListAnswearVC: BaseCellDelegate {
    func onTapCell(_ index: IndexPath) {}
    
    func ontapSpeak(_ txtSpeak: String, index: IndexPath, isPlay: Bool) {
        previousIndex = synthesizer.isSpeaking ? currentIndex : nil
        currentIndex = index
        isPlay ? (makeSpeak(txtSpeak)) : (stopSpeak())
    }

}

//MARK: -AVSpeechSynthesizerDelegate's Method
extension ListAnswearVC: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if(previousIndex == nil && currentIndex != nil) {
            guard let cell = myTableView.cellForRow(at: currentIndex!) as? AnswearCell else { return }
            cell.isPlay = false
        }
        previousIndex = nil
    }
}
