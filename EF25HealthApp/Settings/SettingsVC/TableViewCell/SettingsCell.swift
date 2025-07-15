//
//  SettingsTableViewCell.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 4/7/25.
//

import UIKit

class SettingsCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String, icon: UIImage) {
        titleLabel.text = title
        iconImage.image = icon
    }
}

