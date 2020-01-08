//
//  BaseTableViewController.swift
//  Translate
//
//  Created by admin on 08/01/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class BaseTableViewController: BaseViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var listItem: [Any] = [] {
        didSet {
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    
    var showLoadingIcon = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.showsVerticalScrollIndicator = false
        myTableView.separatorStyle = .none
        fetchData()
    }
    
    // MARK: - Fetch data from API
    func fetchData() {
        if showLoadingIcon {
            SVProgressHUD.show()
        }
    }
    
    func registerCell() {
        
    }
    
    func didFetchData(data: [Any]) {
        listItem = data
    }
    
    // MARK:- Override to use
    func cellForRowAt(item: Any, for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        /** Do something
            ...
        */
        return UITableViewCell()
    }
    
    func didSelectRowAt(selectedItem: Any, indexPath: IndexPath) {
        /** Do something
            ...
        */
    }
    
    func setHeightForRow() -> CGFloat {
        let height: CGFloat = UITableView.automaticDimension
        return height
    }
}

// MARK: - Table view delegate
extension BaseTableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return setHeightForRow()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(selectedItem: listItem[indexPath.row], indexPath: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyBoard()
    }
}

// MARK: - Table view datasource
extension BaseTableViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAt(item: listItem[indexPath.row], for: indexPath, tableView: tableView)
    }
}
