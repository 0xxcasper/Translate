//
//  Delegate.swift
//  Translate
//
//  Created by Sang on 1/9/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import Foundation

@objc protocol BaseCellDelegate: class {
    func onTapCell(_ index: IndexPath)
    @objc optional func ontapSpeak(_ txtSpeak: String, index: IndexPath, isPlay: Bool)
}
