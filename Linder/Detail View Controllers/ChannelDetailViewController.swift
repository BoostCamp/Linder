//
//  ChannelDetailViewController.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 2. 13..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

fileprivate let eventCellID = "eventCell"
fileprivate let segueToEventDetail = "toEventDetail"

class ChannelDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var channel: Channel = Channel()
    private var _searchedEvents: [Event] = []
    private var _events: [Event] = []
    var events: [Event] {
        get {
            if isSearching {
                return _searchedEvents
            }
            return _events
        }
        set (new) {
            self._events = new
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var isSearching: Bool = false
    
    let userDC = UserDataController.shared
    let eventDC = EventDataController.shared
    
    // MARK: - Constants
    private let cellSpacingHeight: CGFloat = 5.0
    let thumbnailCornerRadius: CGFloat = 12.0
    let thumbnailBorderWidth: CGFloat = 0.7
    let thumbnailBorderColor = UIColor.black.cgColor
    
    let buttonCornerRadius: CGFloat = 15.0
    let buttonBorderWidth: CGFloat = 1.2
    let buttonBorderColor = UIColor.ldPuple.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.ldPuple
        //self.view.backgroundColor = UIColor.ldPuple
        
        // Set NavigationBar Title to Channel's Name
        self.title = self.channel.title
        
        // Set Thumbnail Image
        self.thumbnail.image = self.channel.thumbnail
        thumbnail.layer.cornerRadius = thumbnailCornerRadius
        thumbnail.layer.borderWidth = thumbnailBorderWidth
        thumbnail.layer.borderColor = thumbnailBorderColor
        thumbnail.layer.masksToBounds = true
        
        // Set Channel Title
        self.titleLabel.text = self.channel.title
        
        // Set Followers Count
        self.followerCount.text = String(self.channel.followersCount)
        
        // Set Follow Button
        followButton.layer.cornerRadius = buttonCornerRadius
        followButton.layer.borderWidth = buttonBorderWidth
        followButton.layer.borderColor = buttonBorderColor
        followButton.layer.masksToBounds = true
        
        // Set Table View
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "EventSimpleTableViewCell", bundle: nil), forCellReuseIdentifier: eventCellID)
        
        // Load Events Data
        self.events = channel.events
        self.sort(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndex = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: selectedIndex)
            cell?.setSelected(false, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCellID, for: indexPath) as! EventSimpleTableViewCell
        cell.event = events[indexPath.section]
        return cell
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calendarTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueToEventDetail, sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToEventDetail {
            let eventDVC = segue.destination as! EventDetailViewController
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                let selectedEvent = self.tableView.cellForRow(at: selectedIndexPath)  as! EventSimpleTableViewCell
                eventDVC.event = selectedEvent.event
            }
        }
    }
    
    @IBAction func follow(_ sender: Any) {
        userDC.follow(channel: self.channel)
    }

    @IBAction func sort(_ sender: Any) {
        
        let segment = self.segmentedControl.selectedSegmentIndex
        switch segment {
        case 0: // sort by updatedAt
            self.events.sort(by: { (former, later) -> Bool in
                return former.updatedAt > later.updatedAt
            })
        case 1: // sort by participantCount
            self.events.sort(by: { (former, later) -> Bool in
                return former.participantCount > later.participantCount
            })
        case 2: // sort by endedAt
            if !events.isEmpty {
                self.events.sort(by: { (former, later) -> Bool in
                    return former.endDate! > later.endDate!
                })
            }
        default: // Unhandle
            return
        }
    }
    
    @IBAction func search(_ sender: Any) {
        if self.isSearching {
            self.isSearching = false
            self.searchButton.image = #imageLiteral(resourceName: "search_selected")
        } else {
            self.isSearching = true
            self.searchButton.image = #imageLiteral(resourceName: "search_not")
        }
        self.tableView.reloadData()
    }
}
