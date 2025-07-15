//
//  CollectionViewCell.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 4/7/25.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkBox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     // Initialization code
        containerView.layer.cornerRadius = 20
        imageView.setContentHuggingPriority(.required, for: .vertical)
        checkBox.image =  UIImage(named: "empty-checkbox")
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                containerView.layer.borderWidth = 1.5
                containerView.layer.borderColor = UIColor.primary1.cgColor
                checkBox.image = UIImage(named: "filled-checkbox")
            } else {
                containerView.layer.borderColor = UIColor.clear.cgColor
                checkBox.image =  UIImage(named: "empty-checkbox")
            }
        }
    }
    
    func configure(title: String, image: UIImage) {
        titleLabel.text = title
        imageView.image = image
    }
}
