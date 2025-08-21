//
//  ActivityCell.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 20/8/25.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.neutral5
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        layer.borderWidth = 1
        
        valueLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        valueLabel.textColor = UIColor.neutral1
        valueLabel.textAlignment = .left
        
        unitLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        unitLabel.textColor = UIColor.neutral2
        unitLabel.textAlignment = .left
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = UIColor.neutral2
        titleLabel.textAlignment = .left
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    func configure(with item: ActivityItem) {
        iconImg.image = UIImage(systemName: item.icon)
        valueLabel.text = item.value
        unitLabel.text = item.unit
        titleLabel.text = item.label
        
        switch item.label.lowercased() {
        case "steps":
            backgroundColor = UIColor.primary1.withAlphaComponent(0.1)
            layer.borderColor = UIColor.primary1.withAlphaComponent(0.3).cgColor
            iconImg.tintColor = UIColor.primary1
        case "calories":
            backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
            layer.borderColor = UIColor.systemOrange.withAlphaComponent(0.3).cgColor
            iconImg.tintColor = UIColor.systemOrange
        case "distance":
            backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
            layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.3).cgColor
            iconImg.tintColor = UIColor.systemGreen
        case "active time":
            backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
            layer.borderColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
            iconImg.tintColor = UIColor.systemPurple
        default:
            backgroundColor = UIColor.systemGray6
            layer.borderColor = UIColor.systemGray4.cgColor
        }
        valueLabel.textColor = UIColor.neutral1
        
    }
}
