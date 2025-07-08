//
//  SecondVC.swift
//  EF25HealthPlanApp
//
//  Created by iKame Elite Fresher 2025 on 3/7/25.
//

import UIKit

class FourthVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What type of plan would you like to follow?"
        // Do any additional setup after loading the view.
        setupButton()
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupButton() {
        continueBtn.setTitle("Continue", for: .normal)
        continueBtn.backgroundColor = .primary1
        continueBtn.tintColor = .neutral5
        continueBtn.layer.cornerRadius = 16
    }
    

    @IBAction func continueBtnTapped(_ sender: UIButton) {
        
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
extension FourthVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let item = item3[indexPath.item]
        cell.cellConfigure(title: item.title, image: item.image)
        return cell
    }
}
extension FourthVC: UICollectionViewDelegate {
    
}
