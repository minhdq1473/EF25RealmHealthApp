//
//  SecondVC.swift
//  EF25HealthPlanApp
//
//  Created by iKame Elite Fresher 2025 on 3/7/25.
//

import UIKit

class SecondVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Which heart health issue concerns you the most?"
        // Do any additional setup after loading the view.
        setupButton()
        
        collectionView.register(UINib(nibName: "IntroCell", bundle: nil), forCellWithReuseIdentifier: "IntroCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupButton() {
        continueBtn.backgroundColor = .primary
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
extension SecondVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCell", for: indexPath) as! IntroCell
        let item = items[indexPath.item]
        cell.configure(title: item.title, image: item.image)
        return cell
    }
}
extension SecondVC: UICollectionViewDelegate {
    
}
