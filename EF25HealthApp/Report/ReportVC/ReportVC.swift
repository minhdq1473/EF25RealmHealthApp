//
//  ReportVC.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 6/7/25.
//

import UIKit

class ReportVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heartButton: UIButton!
    
    var log: [HealthGuru] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpTitle()
        updateBackgroundView()
    }
    
    func setUpTableView() {
        tableView.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    func setUpTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Health Guru"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textColor = UIColor.neutral1
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    func updateBackgroundView() {
        if log.isEmpty {
            let emptyView = UIView(frame: tableView.bounds)
            let topView = UINib(nibName: "ReportCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ReportCell
            let bottomView = UINib(nibName: "TrackDailyCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! TrackDailyCell
            topView.translatesAutoresizingMaskIntoConstraints = false
            bottomView.translatesAutoresizingMaskIntoConstraints = false
            
            emptyView.addSubview(topView)
            emptyView.addSubview(bottomView)
            
            NSLayoutConstraint.activate([
                topView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 0),
                topView.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 0),
                topView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: 0),
                topView.heightAnchor.constraint(equalToConstant: 92),

                bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 12),
                bottomView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 0),
                bottomView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: 0),
                bottomView.heightAnchor.constraint(equalToConstant: 80)
            ])
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
    }
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        let vc = InputVC()
        vc.inputDelegate = self
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

extension ReportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return log.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        let healthData = log[indexPath.row]
        cell.configure(log: healthData)
        return cell
    }
}

extension ReportVC: UITableViewDelegate {
    
}

extension ReportVC: InputVCDelegate {
    func update(_ log: HealthGuru) {
        self.log.append(log)
        tableView.reloadData()
        updateBackgroundView()
    }
}
