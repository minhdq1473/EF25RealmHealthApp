//
//  IntroVCCollectionViewCell.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 14/7/25.
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

    }
    
    func configure(with items: [collectionCellItem], selectedItems: [Int], selectionCallback: @escaping ([Int]) -> Void) {
        self.items = items
        self.selectedIndices = selectedItems
        self.selectionCallback = selectionCallback
        
        nestedCollectionView.reloadData()
        
        for index in selectedItems {
            let indexPath = IndexPath(item: index, section: 0)
            nestedCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
}

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

extension NestedCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 31) / 2
        return CGSize(width: width, height: 195)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacing: CGFloat) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacing: CGFloat) -> CGFloat {
        return 16
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
}
