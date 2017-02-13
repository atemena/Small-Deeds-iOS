//
//  User.swift
//  Small Deeds
//
//  Created by Andrew Temena on 11/10/16.
//  Copyright © 2016 SmallDeeds. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var username: String
    var token: String
    var id: Int
    var is_superuser: Bool = false
    
    init?(username: String, token: String, id: Int){
        self.username = username
        self.token = token
        self.id = id
    }
}
