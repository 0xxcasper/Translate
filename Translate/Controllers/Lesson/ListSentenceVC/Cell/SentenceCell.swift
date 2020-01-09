//
//  SentenceCell.swift
//  Translate
//
//  Created by Sang on 1/9/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit

class SentenceCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    private lazy var index: IndexPath! = nil
    weak var delegate: BaseCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(_ index: IndexPath, item: Sentence) {
        self.index = index
        lblTitle.text = item.vnese
        lblDetail.text = item.english
    }
    
    @IBAction func onTapCell(_ sender: Any) {
        delegate?.onTapCell(self.index)
    }
}
