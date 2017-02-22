//
//  HomeTableViewController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 31..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//


// NSUserDefault : second lauch detect
import UIKit
import EventKit

fileprivate let channelsCellReuseIdentifier: String = "channelsCell"
fileprivate let calendarCellReuseIdentifier: String = "calendarCell"

fileprivate let segueToEventDetail: String = "toEventDetail"
fileprivate let segueToLoginID = "toLogin"

class HomeTableViewController: UITableViewController {
    
    let eventDC = EventDataController.shared
    var updatedChannels: [Channel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Network Indicator on Status Bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        // TODO : Check log in
        // TODO: Custom myUIViewController and myUITablevie controlelr  OR Protocol programing.
        //
        //performSegue(withIdentifier: segueToLoginID, sender: self)
        
        self.tableView.register(UINib(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: channelsCellReuseIdentifier)
        self.tableView.register(UINib(nibName: "EventSimpleTableViewCell", bundle: nil), forCellReuseIdentifier: calendarCellReuseIdentifier)
        
        eventDC.getRecommandedEvents { (event) in
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row:self.eventDC.recommandedEvents.count - 1, section: 1)], with: .bottom)
            self.tableView.endUpdates()
        }
        
        eventDC.getChannels(scope: .following) { (channel) in
            self.updatedChannels.append(channel)
            if let channelCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ChannelTableViewCell {
                channelCell.channels.append(channel)
                channelCell.insertNewItem()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let logoToNavigationRatio: CGFloat = 0.4
        guard let navigationController = self.navigationController else {
            return
        }
        let navigationBarHeight = navigationController.navigationBar.frame.size.height
        let postLogoHeight = logoToNavigationRatio * navigationBarHeight
        
        let preImage = #imageLiteral(resourceName: "logo_white")
        let postImage = preImage.resize(newHeight: postLogoHeight)
        
        self.navigationItem.leftBarButtonItem?.image = postImage?.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Network Indicator on Status Bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // one for updated channel, the other for recommanded calendars
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = ["최근 업데이트", "추천 캘린더"]
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : // for updated channels
            return 1
        default : // for recommanded calendars
            return eventDC.recommandedEvents.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 : // for updated channels
            let cell = tableView.dequeueReusableCell(withIdentifier: channelsCellReuseIdentifier, for: indexPath) as! ChannelTableViewCell
            cell.channels = self.updatedChannels
            cell.allowsMultipleSelection = false
            cell.containerVC = self
            cell.selectionStyle = .none
            return cell
            
        default : // for recommanded events
            let cell = tableView.dequeueReusableCell(withIdentifier: calendarCellReuseIdentifier, for: indexPath) as! EventSimpleTableViewCell
            let event = eventDC.recommandedEvents[indexPath.row]
            cell.event = event
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 : // for updated channels
            return channelCollectionViewCellHeight + channelTableViewCellPadding * 2
        default : // for recommanded calendars
            return calendarTableViewCellHeight
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0 :
            return false
        default:
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            performSegue(withIdentifier: segueToEventDetail, sender: self)
        default:
            assert(true, "only calendar section can be selected")
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else {
            print("ERROR: Requested segue with no id")
            return
        }
        switch id {
        case segueToEventDetail:
            guard let selectedIndex = self.tableView.indexPathForSelectedRow else {
                print("ERROR: No Cell Sellected")
                return
            }
            let selectedCell = self.tableView.cellForRow(at: selectedIndex) as! EventSimpleTableViewCell
            let selectedEvent = selectedCell.event
            
            let eventDetailVC = segue.destination as! EventDetailViewController
            eventDetailVC.event = selectedEvent
        default:
            return
        }
    }
    

    @IBAction func notificationButtonTouchUpInside(_ sender: Any) {
        print("set Firebase DB")
        eventDC.setFIRDB()
    }
}
