//
//  MyPageTableViewController.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

private let infoCellID = "infoTagCell"
private let interestCellID = "interestTagCell"
private let channelCellID = "channelCell"

class MyPageTableViewController: UITableViewController {
    @IBOutlet weak var profileThumbnailView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!

    @IBOutlet weak var infoTagCollectionView: TagCollectionView!
    @IBOutlet weak var interestTagCollectionView: TagCollectionView!
    @IBOutlet weak var channelCell: ChannelTableViewCell!
    
    let userDC = UserDataController.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: channelCellID)
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
        
        // Tag Collection Views set
        self.infoTagCollectionView.delegate = self
        self.infoTagCollectionView.dataSource = self
        self.infoTagCollectionView.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: infoCellID)
        self.infoTagCollectionView.cellWidth = 70
        
        self.interestTagCollectionView.delegate = self
        self.interestTagCollectionView.dataSource = self
        self.interestTagCollectionView.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: interestCellID)
        self.interestTagCollectionView.cellWidth = 70

        // Channel CELL DATA SET UP
        channelCell.channels = userDC.user.channels
        let flowLayout = channelCell.channelCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: channelCollectionViewCellWidth, height: channelCollectionViewCellHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set Status Bar Color
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = .ldPuple
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // re calculating cell heights for auto sizing
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         // set Status Bar Color to default
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = .clear
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func settingTouchUpInside(_ sender: Any) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 :
            return 80
        case 1:
            return 50
        case 2:
            return interestTagCollectionView.contentSize.height + 17 // 8 * 2 for top & bottom  + 1 for additional
        case 3:
            return channelCell.channelCollectionView.contentSize.height + 17 // 8 * 2 for top & bottom  + 1 for additional
        default:
            return 0
        }
    }
}

extension MyPageTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Collection View DataSouce
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case infoTagCollectionView:
            return 3
        // for interest
        default:
            return userDC.user.hashtags.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case infoTagCollectionView:
            let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellID, for: indexPath) as! TagCollectionViewCell
            let user = userDC.user
            let infos: [String] = [String(user.age.rawValue)+"대" , String(gender: user.gender), user.region]
            // Configure the cell
            cell.titleLabel?.text = infos[indexPath.item]
            return cell
        // for interest
        default:
            let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: interestCellID, for: indexPath) as! TagCollectionViewCell
            // last item is for adding new hashtag
            if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                cell.tagLabel.text = "+"
                cell.titleLabel?.text = "추가"
                cell.setSelected()
                return cell
            }
            let user = userDC.user
            let interests = user.hashtags
            // Configure the cell
            cell.titleLabel?.text = interests[indexPath.item]
            return cell
        }
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        
        if let interest = cell.titleLabel?.text {
            cell.setSelected()
            debugPrint("Follows \(interest)")
            // follow interest
            self.userDC.follow(followable: .hashtags, data: interest)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        if let interest = cell.titleLabel?.text {
            cell.setDeselect()
            debugPrint("UnFollows \(interest)")
            // follow interest
            userDC.unFollow(followable: .hashtags, data: interest)
        }
    }
}
