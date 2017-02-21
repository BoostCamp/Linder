//
//  AgeAndGenderSelectingViewController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 17..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

private let ageCellReuseIdentifier = "ageTagCell"
private let genderCellReuseIdentifier = "genderTagCell"

// TODO : Pop up again when fail.

class AgeAndGenderSelectingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var ageCollectionView: TagCollectionView!
    @IBOutlet weak var genderCollectionView: TagCollectionView!
    
    let userDC = UserDataController.shared
    let agesStrings: [String] = ["10대", "20대", "30대", "40대", "50대", "60이상"]
    let genderStrings: [String] = ["여성", "남성", "기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageCollectionView.delegate = self
        ageCollectionView.dataSource = self
        ageCollectionView.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ageCellReuseIdentifier)
        ageCollectionView.cellWidth = 70
        ageCollectionView.allowsSelection = true
        
        genderCollectionView.delegate = self
        genderCollectionView.dataSource = self
        genderCollectionView.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: genderCellReuseIdentifier)
        genderCollectionView.cellWidth = 70
        genderCollectionView.allowsSelection = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ageCollectionView.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionViewDataSouce
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genderCollectionView{
            return genderStrings.count
        }
            // 선택된 CollectionView가 ageCollectionView
        else {
            return agesStrings.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genderCollectionView{
            let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: genderCellReuseIdentifier, for: indexPath) as! TagCollectionViewCell
            
            // Configure the cell
            cell.titleLabel!.text = genderStrings[indexPath.row]
            return cell
        }
            // 선택된 CollectionView가 ageCollectionView
        else {
            let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ageCellReuseIdentifier, for: indexPath) as! TagCollectionViewCell
            
            // Configure the cell
            cell.titleLabel?.text = agesStrings[indexPath.row]
            
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case genderCollectionView :
            let genderCell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
            
            if let gender = genderCell.titleLabel?.text {
                //genderCell.setSelected()
                debugPrint(gender)
                // Put gender to user
                userDC.putUserData(type: .gender, data: gender)
            }
        default : // 선택된 CollectionView가 ageCollectionView
            let ageCell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
            
            if let age = ageCell.titleLabel?.text {
                //ageCell.setSelected()
                debugPrint(age)
                // Put age to user
                userDC.putUserData(type: .age, data: age)
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
//        //cell.setDeselect()
//    }
}
