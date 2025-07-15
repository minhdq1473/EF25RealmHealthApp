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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    func setupUI() {
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "neutral4")?.cgColor
    }
    
    func configure(labelText: String, placeholder: String) {
        label.text = labelText
        text.placeholder = placeholder
    }
    
    func getTextValue() -> String? {
        guard let text = text.text else {return nil}
        return text
    }
    
    func validateValue(max: Int) -> Int? {
        guard let text = text.text, let intValue = Int(text), (0...max).contains(intValue) else {
            return nil
        }
        return intValue
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
