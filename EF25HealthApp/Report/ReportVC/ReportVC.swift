//
//  ReportVC.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 6/7/25.
//

import UIKit
import RealmSwift

class ReportVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heartButton: UIButton!
    
    var log: [HealthGuru] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setUpTableView()
        setUpTitle()
        updateBackgroundView()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        log = LogRealmManager.shared.getLogs()
        tableView.reloadData()
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
//        vc.inputDelegate = self
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            let vc = InputVC()
            vc.editingLog = self.log[indexPath.row]
            
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            let alert = DeleteAlertVC()
            alert.yesAction = {
                LogRealmManager.shared.remove(id: self.log[indexPath.row].id)
                self.loadData()
            }
            self.present(alert, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            RealmManager.shared.remove(id: log[indexPath.row].id)
//            log.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            updateBackgroundView()
//        }
//    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            let alert = DeleteAlertVC()
            alert.yesAction = { [weak self] in
                guard let self else { return }
                LogRealmManager.shared.remove(id: log[indexPath.row].id)
                loadData()
            }
            self.present(alert, animated: true)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")?.withTintColor(.primary1, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = .background
        
        
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            
            let vc = InputVC()
            vc.editingLog = self.log[indexPath.row]
            
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
            
            completion(true)
        }
        editAction.image = UIImage(systemName: "pencil.circle.fill")?.withTintColor(.systemCyan, renderingMode: .alwaysOriginal)
        editAction.backgroundColor = .background
        
        let config = UISwipeActionsConfiguration(actions: [editAction])
        return config
    }
}

