//
//  AnswearCell.swift
//  Translate
//
//  Created by Sang on 1/9/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit

class AnswearCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imvSpeak: UIImageView!
    
    private lazy var index: IndexPath! = nil
    private lazy var sentence: Sentence! = nil
    weak var delegate: BaseCellDelegate?
    
    var isPlay: Bool! = false {
        didSet {
            imvSpeak.image = isPlay ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "ic_speak")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imvSpeak.isUserInteractionEnabled = true
        imvSpeak.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(_ index: IndexPath, item: Sentence) {
        self.index = index
        self.sentence = item
        lblTitle.text = item.vnese
        lblDetail.text = item.english
        self.isPlay = false
    }
    
    @IBAction func onTapCell(_ sender: Any) {
        self.delegate?.onTapCell(self.index)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.isPlay = !self.isPlay
        delegate?.ontapSpeak?(self.sentence.english, index: index, isPlay: self.isPlay)
    }
}
