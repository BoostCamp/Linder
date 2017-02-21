//
//  FilterViewController.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 2. 21..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

private let tagCellID = "tagCell"
private let sectionCellID = "sectionHeader"

class FilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: TagCollectionView!
    
    
    let regions: [String] = ["전체","서울","인천","경기","강원","대전","충남・세종","충북","광주","전북","전남","부산","울산","경북","경남","제주"]
    let whens: [String] = ["전체", "오늘", "내일", "내일모레", "이번주", "이번주말", "다음주", "다음주말"]
    
    var selectedfilters: [[String]] = [ [], [] ]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set navigation title color
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.ldPuple]
        
        // set Navigation Delegate for passing Filtering data to SearchVC
        self.navigationController?.delegate = self
        
        // set Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: tagCellID)
        collectionView.register(UINib.init(nibName: "TagCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionCellID)
        collectionView.cellWidth = 70
        collectionView.SectionHeight = 25
        collectionView.allowsMultipleSelection = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
        let filters = [regions, whens]
        
        for sectionIndex in 0..<selectedfilters.count {
            for item in selectedfilters[sectionIndex] {
                guard let itemIndex = filters[sectionIndex].index(of: item) else {
                    print("Passed Filter Data is Invalid!")
                    return
                }
                let selectingIndex = IndexPath(item: itemIndex, section: sectionIndex)
                collectionView.selectItem(at: selectingIndex, animated: true, scrollPosition: UICollectionViewScrollPosition.top)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collection View DataSouce
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // one for Regions, the other for whens
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: // Regions
            return self.regions.count
        default: // Whens
            return self.whens.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellID, for: indexPath) as! TagCollectionViewCell
        
        switch indexPath.section {
        case 0: // Region
            // Configure the cell
            cell.titleLabel?.text = regions[indexPath.item]
        default: // Whens
            // Configure the cell
            cell.titleLabel?.text = whens[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView: TagCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionCellID, for: indexPath) as! TagCollectionReusableView
            
            headerView.sectionLabel.text = ["지역", "기간"][indexPath.section]
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: - Collection View Delegate

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        
        guard let selection = cell.titleLabel?.text else {
            print("You selected Invalide Tag")
            return false
        }
        
        if selection == "전체" {
            // deselect all in that section
            if let selectedIndexes = self.collectionView.indexPathsForSelectedItems {
                let selectedInSection = selectedIndexes.filter({ (index) -> Bool in
                    return index.section == indexPath.section
                })
                for index in selectedInSection {
                    self.collectionView.deselectItem(at: index, animated: true)
                }
            }
        } else {
            // 다른 셀을 누르면 "전체" 셀은 비선택
            self.collectionView.deselectItem(at: IndexPath(item: 0, section: indexPath.section), animated: true)
        }
        return true
    }
}

extension FilterViewController : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let searchVC = viewController as? SearchViewController {

            guard let selectedIndexes = self.collectionView.indexPathsForSelectedItems else {
                print("User selected no filter")
                return
            }
            let filters = [regions, whens]
            
            let selectedRegions: Array<String> = []
            let selectedWhens: Array<String> = []
            self.selectedfilters = [selectedRegions, selectedWhens]
            
            for index in selectedIndexes {
                selectedfilters[index.section].append(filters[index.section][index.item])
            }
        
            searchVC.filters = selectedfilters
        }

    }
}
