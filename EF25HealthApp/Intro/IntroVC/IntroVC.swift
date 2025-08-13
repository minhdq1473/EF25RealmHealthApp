//
//  IntroVC.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 14/7/25.
//

import UIKit

class IntroVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var currentPage = 0
    private let titles = [
        "Which heart health issue concerns you the most?",
        "What would you like to achieve?",
        "What type of plan would you like to follow?"
    ]
    
    private let dataSets = [item1, item2, item3]
    private var selectedItems: [[Int]] = [[], [], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
        setupCollectionView()
        updateTitle()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // nếu ko có hàm này, cell đầu (collection view đầu) của em sẽ hơi lệch bên phải
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if currentPage == 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }

    @IBAction func continueBtnTapped(_ sender: UIButton) {
        if currentPage < 2 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
            updateTitle()
            updateButtonState()
        } else {
//            let vc = TabBarCtrler()
//            navigationController?.pushViewController([vc], animated: true)
            let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
            window?.rootViewController = TabBarController()
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        }
    }
    
    private func setupUI() {
        navigationItem.hidesBackButton = true
    }
    
    private func setupButton() {
        continueBtn.setTitle("Continue", for: .normal)
        continueBtn.layer.cornerRadius = 16
        continueBtn.isEnabled = false
        continueBtn.setTitleColor(.neutral5, for: .disabled)
        continueBtn.backgroundColor = .neutral3
        continueBtn.tintColor = .neutral5
        continueBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "NestedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NestedCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
    }
    
    private func updateTitle() {
        titleLabel.text = titles[currentPage]
    }
    
    private func updateButtonState() {
        let currentSelectedCount = selectedItems[currentPage].count
        
        if currentSelectedCount > 0 {
            continueBtn.isEnabled = true
            continueBtn.backgroundColor = .primary1
        } else {
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = .neutral3
        }
    }
}

extension IntroVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NestedCollectionViewCell", for: indexPath) as! NestedCollectionViewCell
        cell.configure(with: dataSets[indexPath.item], selectedItems: selectedItems[indexPath.item]) { [weak self] selectedIndices in
            self?.selectedItems[indexPath.item] = selectedIndices
            self?.updateButtonState()
        }
        return cell
    }
}
extension IntroVC: UICollectionViewDelegate {
    
}



