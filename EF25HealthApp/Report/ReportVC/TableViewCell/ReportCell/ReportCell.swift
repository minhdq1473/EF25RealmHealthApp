//
//  ReportCell.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 7/7/25.
//

import UIKit

class ReportCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var pulseLabel: UILabel!
    @IBOutlet weak var hrvLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bpmPulse: UILabel!
    @IBOutlet weak var bpmHrv: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStackView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupStackView() {
        stackView.layer.cornerRadius = 12
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func configure(log: HealthGuru) {
        pulseLabel.text = String(log.pulse)
        hrvLabel.text = String(log.HRV)
        let status = log.getStatus(pulse: log.pulse)
        statusLabel.text = status.rawValue
        pulseLabel.textColor = status.color
        hrvLabel.textColor = status.color
        statusLabel.textColor = status.color
        bpmHrv.textColor = status.color
        bpmPulse.textColor = status.color
    }
    
}
