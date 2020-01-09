//
//  ListTopicVC.swift
//  Translate
//
//  Created by Sang on 1/8/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit
import Firebase

class ListTopicVC: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(title: TITLE_LIST_TOPIC)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddNewTopic))
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
    
    override func cellForRowAt(item: Any, for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeue(TopicTableViewCell.self, for: indexPath)
        cell.setupCell(index: indexPath, text: (item as! Topic).title)
        cell.delegate = self
        return cell
    }
    
    override func editCell(item: Any, indexPath: IndexPath, type: UITableViewCell.EditingStyle) {
        if(type == .delete) {
            Firebase.shared.deleteTopic((item as! Topic).id)
        }
    }
    
    @objc func didTapAddNewTopic() {
        PopUpHelper.shared.showAlertWithTextField(self, kTopic, kImportNameTopic) { (text) in
            Firebase.shared.createTopic(text)
        }
    }
}

extension ListTopicVC: BaseCellDelegate {
    func onTapCell(_ index: IndexPath) {
        let listSentenceVC = ListSentenceViewController()
        listSentenceVC.topic = listItem[index.row] as? Topic
        self.push(controller: listSentenceVC)
    }
}

