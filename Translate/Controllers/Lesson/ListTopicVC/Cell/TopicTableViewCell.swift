//
//  TopicTableViewCell.swift
//  Translate
//
//  Created by admin on 08/01/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit
protocol TopicTableViewCellDelegate: class {
    func didTapCheckBox(isSelect: Bool, index: IndexPath)
}

class TopicTableViewCell: BaseTableViewCell {
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    private lazy var index: IndexPath! = nil
    weak var delegate: BaseCellDelegate?
    
    weak var delegate1: TopicTableViewCellDelegate!
    var isSelect: Bool = false {
        didSet {
            if isSelect {
                btnCheckBox.backgroundColor = .red
            } else {
                btnCheckBox.backgroundColor = .white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCheckBox.layer.borderWidth = 1
        btnCheckBox.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(index: IndexPath, text: String) {
        self.lblTitle.text = text
        self.index = index
    }
    
    @IBAction func onTapCheckBox(_ sender: UIButton) {
        self.isSelect = !self.isSelect
        self.delegate1.didTapCheckBox(isSelect: self.isSelect, index: self.index)
    }
    
    @IBAction func onTapCell(_ sender: Any) {
        self.delegate?.onTapCell(self.index)
    }
}
