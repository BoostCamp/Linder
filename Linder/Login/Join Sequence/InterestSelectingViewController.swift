//
//  InterestSelectingViewController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 19..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

private let interestCellReuseIdentifier = "interestTagCell"
private let sectionCellReuseIdentifier = "interestSectionHeader"

class InterestSelectingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var interestCollectionView: TagCollectionView!
    
    let userDC = UserDataController.shared
    
    let interests: [String : [String]] = [
        "문화" : ["콘서트", "영화", "음악", "전시", "축제", "연극", "뮤지컬", "오페라"],
        "쇼핑" : ["라이프", "뷰티", "패션", "푸드", "테크", "아울렛", "백화점", "면세점"],
        "스포츠" : ["야구", "축구", "농구", "배구", "UFC", "테니스", "골프", "피겨"],
        "생활/여행" : ["기차", "버스", "항공", "대학", "공채", "호텔", "여행", "천문"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("AgeAndGenderSelectionViewController",view.frame.width)
        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        interestCollectionView.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: interestCellReuseIdentifier)
        interestCollectionView.register(UINib.init(nibName: "TagCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionCellReuseIdentifier)
        interestCollectionView.preferredCellWidth = 70
        interestCollectionView.SectionHeight = 25
        interestCollectionView.allowsMultipleSelection = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        interestCollectionView.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collection View DataSouce
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return interests.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let targetSection: [String] = Array(interests.values)[section]
        return targetSection.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: interestCellReuseIdentifier, for: indexPath) as! TagCollectionViewCell
        
        let targetSection: [String] = Array(interests.values)[indexPath.section]
        // Configure the cell
        cell.titleLabel?.text = targetSection[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView: TagCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionCellReuseIdentifier, for: indexPath) as! TagCollectionReusableView
            headerView.sectionLabel.text = Array(interests.keys)[indexPath.section]
            
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        
        if let interest = cell.titleLabel?.text {
            //cell.setSelected()
            debugPrint("Follows \(interest)")
            // follow interest
            //userDC.follow(followable: .hashtags, data: interest)
            userDC.user.hashtags.append(interest)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        if let interest = cell.titleLabel?.text {
            //cell.setDeselect()
            debugPrint("UnFollows \(interest)")
            // follow interest
            //userDC.unFollow(followable: .hashtags, data: interest)
            let index = userDC.user.hashtags.index(of: interest)
            userDC.user.hashtags.remove(at: index!)
        }
    }
}
