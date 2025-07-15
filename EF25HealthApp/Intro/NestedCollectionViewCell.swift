//
//  NestedCollectionViewCell.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 4/7/25.
//

import UIKit

class NestedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nestedCollectionView: UICollectionView!
    
    private var items: [collectionCellItem] = []
    private var selectedIndices: [Int] = []
    private var selectionCallback: (([Int]) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        nestedCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        nestedCollectionView.delegate = self
        nestedCollectionView.dataSource = self
        nestedCollectionView.allowsMultipleSelection = true
        nestedCollectionView.showsVerticalScrollIndicator = false
    }
    
    func configure(with items: [collectionCellItem], selectedItems: [Int], selectionCallback: @escaping ([Int]) -> Void) {
        self.items = items
        self.selectedIndices = selectedItems
        self.selectionCallback = selectionCallback
        
        // Restore selected state
        nestedCollectionView.reloadData()
        
        // Select previously selected items
        for index in selectedItems {
            let indexPath = IndexPath(item: index, section: 0)
            nestedCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
}

// MARK: - UICollectionViewDataSource
extension NestedCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let item = items[indexPath.item]
        cell.configure(title: item.title, image: item.image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension NestedCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !selectedIndices.contains(indexPath.item) {
            selectedIndices.append(indexPath.item)
        }
        selectionCallback?(selectedIndices)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndices.removeAll { $0 == indexPath.item }
        selectionCallback?(selectedIndices)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NestedCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 2 // 2 columns with spacing
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacing: CGFloat) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacing: CGFloat) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
} 