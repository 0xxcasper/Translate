//
//  ListSpeakVC.swift
//  Translate
//
//  Created by Sang on 1/8/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ListSpeakVC: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(title: TITLE_CHOOSE_TOPIC)
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
    
    @IBAction func didTapTrainSpeak(_ sender: UIButton) {
        let topicsSelected = (self.listItem as! [Topic]).filter({ $0.isSelect == true })
        if topicsSelected.count > 0 {
            let trainSpkVC = TrainSpeakViewController()
            trainSpkVC.topics = topicsSelected
            self.push(controller: trainSpkVC)
        } else {
            SVProgressHUD.showInfo(withStatus: "Xin hãy chọn chủ đề để luyện nghe")
        }
    }
}

extension ListSpeakVC: TopicTableViewCellDelegate
{
    func didTapCheckBox(isSelect: Bool, index: IndexPath) {
        (self.listItem[index.row] as! Topic).isSelect = !(self.listItem[index.row] as! Topic).isSelect
    }
}
