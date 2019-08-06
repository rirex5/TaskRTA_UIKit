//
//  CompleteTaskTableViewCell.swift
//  TaskRTA
//
//  Created by Mercury on 2019/07/26.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit

class CompleteTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
