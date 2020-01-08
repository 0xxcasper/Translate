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
