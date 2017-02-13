//
//  Deed.swift
//  Small Deeds
//
//  Created by Andrew Temena on 10/23/16.
//  Copyright © 2016 SmallDeeds. All rights reserved.
//

import UIKit

class Deed {
    // MARK: Properties

    var title: String
    var description: String
    var impact: Int
    var type:Int
    var inactive_pledges: Int
    var active_pledges: Int
    var id: Int
    
    // MARK: Initialization
    init?(title: String, description: String, id: Int){
        self.title = title
        self.description = description
        self.impact = Int(arc4random_uniform(6)+1)
        self.type = 0
        self.inactive_pledges = Int(arc4random_uniform(6)+1)
        self.active_pledges = Int(arc4random_uniform(6)+1)
        self.id = id
        
        // Initialization should fail if there is no name or if the rating is negative.
        if title.isEmpty {
            return nil
        }
    }
    
    
    
}
