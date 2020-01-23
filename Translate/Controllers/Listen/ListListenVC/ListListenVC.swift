//
//  ListListenVC.swift
//  Translate
//
//  Created by Sang on 1/8/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class ListListenVC: BaseTableViewController {
    
    private var textSpeak: String = ""
    private let synthesizer = AVSpeechSynthesizer()
    private var isMakeSpeak: Bool = false
    @IBOutlet weak var btnSpeak: UIButton!
    @IBOutlet weak var lblSpeak: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        self.setTitle(title: TITLE_CHOOSE_TOPIC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabbar()
    }
    
    override func registerCell() {
        super.registerCell()
        myTableView.registerXibFile(TopicTableViewCell.self)
    }
    
    override func fetchData() {
        super.fetchData()
        Firebase.shared.getAllTopic { (topics) in
            self.didFetchData(data: topics)
        }
    }
    
    override func canEditRow() -> Bool {
        return false
    }
    
    override func cellForRowAt(item: Any, for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeue(TopicTableViewCell.self, for: indexPath)
        cell.setupCell(index: indexPath, text: (item as! Topic).title)
        cell.isSelect = (item as! Topic).isSelect
        cell.delegate1 = self
        return cell
    }

    @IBAction func didTapTrainListen(_ sender: Any) {
        isMakeSpeak = !isMakeSpeak
        if(isMakeSpeak) {
            lblSpeak.text = "Dừng luyện nghe tiếng anh"
            let topicsSelected = (self.listItem as! [Topic]).filter({ $0.isSelect == true })
            if topicsSelected.count > 0 {
                getAllSentenceAndAnswer(topics: topicsSelected) { (text) in
                    self.textSpeak = text
                    self.makeSpeak()
                }
            } else {
                SVProgressHUD.showInfo(withStatus: "Xin hãy chọn chủ đề để luyện nghe")
            }
        } else {
            lblSpeak.text = "Luyện nghe tiếng anh"
            stopSpeak()
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopSpeak()
    }
    
    private func makeSpeak() {
        let utterance = self.textSpeak.configAVSpeechUtterance()
        self.synthesizer.speak(utterance)

    }
    
    private func stopSpeak() {
        if(self.synthesizer.isSpeaking) {
            self.synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    private func getAllSentenceAndAnswer(topics: [Topic], _ completion: @escaping (String)->()) {
        self.textSpeak = ""
        Firebase.shared.getAllSentencesAndAnswears(topics) { (sentenceAnswers) in
            var textSpeak = ""
            for sentence in sentenceAnswers {
                textSpeak += sentence.key.english ?? ""
                for value in sentence.value {
                    textSpeak += value.english
                }
            }
            completion(textSpeak)
        }
    }

}

extension ListListenVC: TopicTableViewCellDelegate, AVSpeechSynthesizerDelegate {
    func didTapCheckBox(isSelect: Bool, index: IndexPath) {
        (self.listItem[index.row] as! Topic).isSelect = !(self.listItem[index.row] as! Topic).isSelect
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if(isMakeSpeak) {
           makeSpeak()
        }
    }
}

