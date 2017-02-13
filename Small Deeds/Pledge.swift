//
//  Pledge.swift
//  Small Deeds
//
//  Created by Andrew Temena on 11/8/16.
//  Copyright © 2016 SmallDeeds. All rights reserved.
//

import UIKit

class Pledge: NSObject {

    var deed: Int
    var threshold: Int
    var active: Bool
    var id: Int?
    
    init( deed: Int, threshold: Int, active: Bool?){
        self.deed = deed
        self.threshold = threshold
        self.active = active ?? false
    }
    
    func asDictionary() -> Dictionary<String, AnyObject>{
        return ["deed": deed as AnyObject, "threshold": threshold as AnyObject, "active": active as AnyObject, "id": id as AnyObject]
    }
    
}
