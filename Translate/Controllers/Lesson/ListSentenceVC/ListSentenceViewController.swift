//
//  ListSentenceViewController.swift
//  Translate
//
//  Created by admin on 08/01/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit

class ListSentenceViewController: BaseTableViewController {

    var topic: Topic!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.setTitle(title: TITLE_LIST_SAYING)
    }
    
    override func registerCell() {
        super.registerCell()
        myTableView.registerXibFile(SentenceCell.self)
    }
    
    override func fetchData() {
        super.fetchData()
        Firebase.shared.getAllSentence(topic.id) { (reponse) in
            guard let sentences = reponse else { return }
            self.didFetchData(data: sentences)
        }
    }
    
    override func cellForRowAt(item: Any, for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeue(SentenceCell.self, for: indexPath)
        cell.setupCell(indexPath, item: item as! Sentence)
        cell.delegate = self
        return cell
    }
    
    override func editCell(item: Any, indexPath: IndexPath, type: UITableViewCell.EditingStyle) {
        if (type == .delete) {
            Firebase.shared.deleteSentence(self.topic.id, (item as! Sentence).id)
        }
    }
        
    @IBAction func actAddNewSentence(_ sender: Any) {
        PopUpHelper.shared.showAlertWithTextField(self, kNewSentence, kImportDetailSentence) { (text) in
            Firebase.shared.createSentence(text, self.topic.id, isVN: true)
        }
    }
}

extension ListSentenceViewController: BaseCellDelegate {
    func onTapCell(_ index: IndexPath) {
        let listAnswearVC = ListAnswearVC()
        listAnswearVC.sentence = listItem[index.row] as? Sentence
        listAnswearVC.topic = topic
        self.push(controller: listAnswearVC)
    }
}
