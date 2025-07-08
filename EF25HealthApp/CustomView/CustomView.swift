//
//  InputViewVC.swift
//  EF25NavigationApp
//
//  Created by iKame Elite Fresher 2025 on 25/6/25.
//

import UIKit

class CustomView: UIView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var text: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
                
//        view.layer.cornerRadius = 15
//        backgroundColor = .background
        
//        let avatar = UIImageView(image: UIImage(named: "Image"))
//        avatar.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
//        avatar.contentMode = .scaleAspectFill
//        self.addSubview(avatar)
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    override func layoutSubviews() {
        
    }
    
    private func loadFromNib() {
        let nib = UINib(nibName: "CustomView", bundle: nil)
        let nibView = nib.instantiate(withOwner: self)[0] as! UIView
        
        addSubview(nibView)
        nibView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nibView.topAnchor.constraint(equalTo: topAnchor),
            nibView.bottomAnchor.constraint(equalTo: bottomAnchor),
            nibView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nibView.trailingAnchor.constraint(equalTo: trailingAnchor)])
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
