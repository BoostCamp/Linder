//
//  RegionSelectingViewController.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 1. 20..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

private let regionCellReuseIdentifier = "regionTagCell"

class RegionSelectingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var regionCollectionView: TagCollectionView!
    
    let userDC = UserDataController.shared
    let regions: [String] = ["서울","인천","경기","강원","대전","충남・세종","충북","광주","전북","전남","부산","울산","경븍","경남","제주"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("AgeAndGenderSelectionViewController",view.frame.width)
        regionCollectionView.delegate = self
        regionCollectionView.dataSource = self
        regionCollectionView.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: regionCellReuseIdentifier)
        regionCollectionView.cellWidth = 70
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - CollectionViewDataSouce
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: regionCellReuseIdentifier, for: indexPath) as! TagCollectionViewCell
        // Configure the cell
        cell.titleLabel?.text = regions[indexPath.row]
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        
        if let region = cell.titleLabel?.text {
            cell.setSelected()
            // Put region to user
            userDC.setRegion(regionName: region)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        cell.setDeselect()
    }
}
