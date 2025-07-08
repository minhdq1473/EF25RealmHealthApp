//
//  ReportVC.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 6/7/25.
//

import UIKit

class ReportVC: UIViewController {
    var log: [HealthGuru] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heartButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always

//        navigationController?.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32, weight: .semibold),
//            NSAttributedString.Key.foregroundColor: UIColor.neutral1
//            NSAttributedString.Key.paragraphStyle: {
//                let style = NSMutableParagraphStyle()
//                style.alignment = .left
//                return style
//            }()
//        ]
        

        
        
        
        tableView.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        // Do any additional setup after loading the view.
        setUpTitle()
        updateBackgroundView()
        navigationItem.leftBarButtonItem = nil
//        heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
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
    
    func setUpTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Health Guru"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textColor = UIColor.neutral1
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        let vc = InputVC()
        vc.inputDelegate = self
        navigationController?.pushViewController(vc, animated: true)
        tabBarController?.isTabBarHidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
