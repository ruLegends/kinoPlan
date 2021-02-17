//
//  SpacexTableViewCell.swift
//  kinoplanTest
//
//  Created by A on 16.02.2021.
//  Copyright © 2021 test. All rights reserved.
//

import UIKit

class SpacexTableViewCell: UITableViewCell {

    @IBOutlet weak var missionNameLabel: UILabel!
    @IBOutlet weak var missionImage: UIImageView!
    @IBOutlet weak var rocketName: UILabel!
    @IBOutlet weak var launchDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
