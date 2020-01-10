//
//  AppConstant.swift
//  Translate
//
//  Created by Sang on 1/8/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    static let SCREEN_SIZE: CGRect = UIScreen.main.bounds
    static let SREEEN_WIDTH = SCREEN_SIZE.width
    static let SCREEN_HEIGHT = SCREEN_SIZE.height
    static let STATUS_BAR_BOTTOM = SCREEN_HEIGHT >= 812 || SREEEN_WIDTH >= 812 ? CGFloat(37) : CGFloat(0)
    static let STATUS_BAR_TOP = SCREEN_HEIGHT >= 812 ? CGFloat(44) : CGFloat(20)
    static let TOOL_BAR_HEIGHT = CGFloat(44)
    static let TAB_BAR_HEIGHT = CGFloat(49)
    static let HEIGTH_TABBAR: CGFloat = 70 + STATUS_BAR_BOTTOM
}

//Mark: Title Controllers
let TITLE_LIST_TOPIC   = "DANH SÁCH CHỦ ĐỀ"
let TITLE_LIST_SAYING  = "DANH SÁCH CÂU THOẠI"
let TITLE_LIST_QUETION = "CÂU HỎI"
let TITLE_CHOOSE_TOPIC = "CHỌN CHỦ ĐỀ"
let TITLE_TRAIN_SPEAK  = "LUYỆN TẬP NÓI"


//Mark: Firebase KEY
let TOPIC                   = "Topics"
let SENTENCES               = "Sentences"
let ANSWEARS                = "Answears"
let TITLE                   = "title"
let ID                      = "id"
let USER                    = "Users"
let INFOR                   = "Infor"
let NAME                    = "name"
let EMAIL                   = "email"
let ENGLISH                 = "english"
let VNESE                   = "vnese"

//Mark: String
let kEmpty                  = ""
let kTopic                  = "Chủ đề"
let kImportNameTopic        = "Nhập vào tên của chủ đề"
let kNewSentence            = "Câu thoại"
let kImportDetailSentence   = "Nhập vào nội dung câu thoại"
let kOK                     = "OK"
