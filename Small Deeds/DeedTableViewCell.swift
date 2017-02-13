//
//  DeedTableViewCell.swift
//  Small Deeds
//
//  Created by Andrew Temena on 10/23/16.
//  Copyright © 2016 SmallDeeds. All rights reserved.
//

import UIKit

class DeedTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var deedTitleLabel: UILabel!
    @IBOutlet weak var deedDescriptionTextView: UITextView!
    @IBOutlet weak var deedPledgeButton: UIButton!
    @IBOutlet weak var deedPledgeStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
