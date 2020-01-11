//
//  Sentence.swift
//  Translate
//
//  Created by Sang on 1/9/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import Foundation

struct Sentence: Hashable {
    var id:String!
    var english:String!
    var vnese:String!
    
    init(_ data: [String:AnyObject]) {
        english = data["english"] as? String
        vnese = data["vnese"] as? String
        id = data["id"] as? String
    }
}
