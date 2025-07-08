//
//  TrackDailyCell.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 7/7/25.
//

import UIKit

class TrackDailyCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    
}
