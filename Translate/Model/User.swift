//
//  User.swift
//  RemindMe
//
//  Created by QUỐC on 6/27/19.
//  Copyright © 2019 QUỐC. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var id:String!
    var name:String!
    var email:String!
    
    init(_ data: [String:AnyObject]) {
        id = data["id"] as? String
        name = data["name"] as? String
        email = data["email"] as? String
    }
}
