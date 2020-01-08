//
//  Topic.swift
//  Translate
//
//  Created by admin on 08/01/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import Foundation
import UIKit

struct Topic {
    
    var id:String!
    var title:String!
    
    init(_ data: [String:AnyObject]) {
        id = data["id"] as? String
        title = data["title"] as? String
    }
}
