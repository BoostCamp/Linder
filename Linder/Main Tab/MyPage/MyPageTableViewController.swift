//
//  MyPageTableViewController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

private let infoCellID = "infoTagCell"
private let interestCellID = "interestTagCell"
private let channelCellID = "channelCell"

private let segueToChannelDetailID = "toChannelDetail"

class MyPageTableViewController: UITableViewController {
//    @IBOutlet weak var profileThumbnailView: UIImageView!
//    @IBOutlet weak var userName: UILabel!
//    @IBOutlet weak var userID: UILabel!

    @IBOutlet weak var infoTagCollectionView: TagCollectionView!
    @IBOutlet weak var interestTagCollectionView: TagCollectionView!
    @IBOutlet weak var channelCell: ChannelTableViewCell!
    
    let userDC = UserDataController.shared
    let eventDC = EventDataController.shared
    
    let infoCellDelegate = MyPageInfoCellDelegate()
    let interestCellDelegate = MyPageInterestCellDelegate()
    
    
    // MARK: - Constants
    let navigationMoveDuration = 0.3
    let thumbnailCornerRadius: CGFloat = 22.5 //ChannelCollectionViewCell.cornerRadius
    let thumbnailBorderWidth: CGFloat = 0.5
    let thumbnailBorderColor = UIColor.black.cgColor
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up table view
        self.tableView.register(UINib(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: channelCellID)
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
        
        // Tag Collection Views set
        self.infoTagCollectionView.delegate = infoCellDelegate
        self.infoTagCollectionView.dataSource = self
        self.infoTagCollectionView.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: infoCellID)
        self.infoTagCollectionView.preferredCellWidth = 70
        self.infoTagCollectionView.allowsSelection = false
        
        self.interestTagCollectionView.delegate = interestCellDelegate
        self.interestTagCollectionView.dataSource = self
        self.interestTagCollectionView.register(UINib.init(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: interestCellID)
        self.interestTagCollectionView.preferredCellWidth = 70

        // temporary channel for set layout
        channelCell.channels = userDC.user.channelIDs.map({ (id) -> Channel in
            print("id:" , id)
            return Channel(id: id)
        })
        channelCell.allowsMultipleSelection = false
        channelCell.containerVC = self
        let flowLayout = channelCell.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: channelCollectionViewCellWidth, height: channelCollectionViewCellHeight)
        
        
//        // Set User Date
//        userName.text = userDC.user.name
//        userID.text = "@"+String(userDC.user.nickName)
//        profileThumbnailView.image = userDC.user.thumbnail
//        profileThumbnailView.layer.cornerRadius = thumbnailCornerRadius
//        profileThumbnailView.layer.borderWidth = thumbnailBorderWidth
//        profileThumbnailView.layer.borderColor = thumbnailBorderColor
//        profileThumbnailView.layer.masksToBounds = true
        
        eventDC.getChannels(scope: .following) { (channel) in
            if let index = self.userDC.user.channelIDs.index(of: channel.id) {
                self.channelCell.channels[index] = channel
                
                let cell = self.channelCell.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ChannelCollectionViewCell
                cell.channel = channel
                
                self.channelCell.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // for smooth navigation apearing and disapearing
//        self.navigationController?.view.backgroundColor = .ldPuple
//        self.edgesForExtendedLayout = .bottom
//        self.extendedLayoutIncludesOpaqueBars = true
//
//        // set Status Bar Color
//        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//        statusBar?.backgroundColor = .ldPuple
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // hide navigation bar
//        UIView.animate(withDuration: navigationMoveDuration, animations: {
//            self.navigationController?.isNavigationBarHidden = true
//        })
        
        // re calculating cell heights for auto sizing
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
//        self.navigationController?.viewControllers.last?.extendedLayoutIncludesOpaqueBars = true
//        self.navigationController?.viewControllers.last?.edgesForExtendedLayout = .top
//        
//        UIView.animate(withDuration: navigationMoveDuration, animations: {
//            // show navigation bar
//            self.navigationController?.isNavigationBarHidden = false
//            self.navigationController?.navigationBar.barStyle = .black
//            UIApplication.shared.statusBarStyle = .lightContent
//            
//            // set Status Bar BackGround Color to default
//            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//            statusBar?.backgroundColor = .clear
//        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //self.navigationController?.viewControllers.last?.extendedLayoutIncludesOpaqueBars = false
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
//        case 0 :
//            return 80
        case 0:
            return 50
        case 1:
            return interestTagCollectionView.contentSize.height + 17 // 8 * 2 for top & bottom  + 1 for additional
        case 2:
            return channelCell.collectionView.contentSize.height + 17 // 8 * 2 for top & bottom  + 1 for additional
        default:
            return 0
        }
    }
    
    @IBAction func updatedUserData () {
        self.infoTagCollectionView.reloadData()
        self.interestTagCollectionView.reloadData()
        self.channelCell.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
}

extension MyPageTableViewController: UICollectionViewDataSource {
    
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
            return userDC.user.hashtags.count// + 1
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
//            if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
//                cell.tagLabel.text = "+"
//                cell.titleLabel?.text = "추가"
//                cell.titleLabel.textColor = .white
//                cell.tagLabel.textColor = .white
//                cell.backgroundColor = UIColor.ldPuple
//                cell.selectedBackgroundView?.backgroundColor = .white
//                return cell
//            }
            let user = userDC.user
            let interests = user.hashtags
            // Configure the cell
            cell.titleLabel?.text = interests[indexPath.item]
            return cell
        }
    }
}

class MyPageInfoCellDelegate: NSObject, UICollectionViewDelegate {
    
    let userDC = UserDataController.shared
    
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        cell.isSelected = true
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        switch indexPath.item {
        case 0: // age
            debugPrint("TODO : Age Select View")
        case 1: // gender
            debugPrint("TODO : Gender Select View")
        default: // region
            debugPrint("TODO : Region Select View")
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        cell.isSelected = false
    }
}

class MyPageInterestCellDelegate: NSObject, UICollectionViewDelegate {
    
    let userDC = UserDataController.shared

    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if indexPath.item == userDC.user.hashtags.count {
            let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
            cell.titleLabel.textColor = .ldPuple
            cell.tagLabel.textColor = .ldPuple
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // last adding cell
        debugPrint("TODO : Interest Add View")
        let cell = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        collectionView.deselectItem(at: indexPath, animated: true)//selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        //cell.isSelected = false
        cell.titleLabel.textColor = .white
        cell.tagLabel.textColor = .white
    }
}
