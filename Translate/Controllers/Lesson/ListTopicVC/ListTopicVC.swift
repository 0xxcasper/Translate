//
//  ListTopicVC.swift
//  Translate
//
//  Created by Sang on 1/8/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit

class ListTopicVC: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(title: "DANH SÁCH CHỦ ĐỀ")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddNewTopic))
    }
    
    override func registerCell() {
        super.registerCell()
        myTableView.registerXibFile(TopicTableViewCell.self)
    }
    
    override func fetchData() {
        super.fetchData()
        Firebase.shared.getAllTopic { (Topics) in
            guard let topics = Topics else { return }
            self.didFetchData(data: topics)
        }
    }
    
    override func cellForRowAt(item: Any, for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeue(TopicTableViewCell.self, for: indexPath)
        cell.lblTitle.text = (item as! Topic).title
        return cell
    }
    
    override func didSelectRowAt(selectedItem: Any, indexPath: IndexPath) {
        let listSentenceVC = ListSentenceViewController()
        listSentenceVC.topic = selectedItem as? Topic
        self.push(controller: listSentenceVC)
    }
    
    @objc func didTapAddNewTopic() {
        PopUpHelper.shared.showAlertWithTextField(self, "Chủ đề", "Nhập vào tên của chủ đề") { (text) in
            Firebase.shared.createTopic(text)
        }
    }

}
