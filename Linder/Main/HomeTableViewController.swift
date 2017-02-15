//
//  HomeTableViewController.swift
//  Linder
//
//  Created by 박종훈 on 2017. 1. 31..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import EventKit

fileprivate let channelsCellReuseIdentifier: String = "channelsCell"
fileprivate let calendarCellReuseIdentifier: String = "calendarCell"

fileprivate let segueToEventDetail: String = "toEventDetail"

class HomeTableViewController: UITableViewController {
    
    var recommandedEvents: [Event] = []
    var LinderEventStore: EKEventStore?
    
    let eventDC = EventDataController.shared
    let channels: [String] = ["뮤지컬 팬텀", "삼총사", "뮤지컬 엘리자벳", "록키호러쇼", "위키드", "넥센 히어로즈", "삼성 라이온즈", "두산 베어스", "한화 이글스", "엘지 트윈스"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: channelsCellReuseIdentifier)
        self.tableView.register(UINib(nibName: "CalendarTableViewCell", bundle: nil), forCellReuseIdentifier: calendarCellReuseIdentifier)
        recommandedEvents = eventDC.getRecommandedEvents()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : // for updated channels
            return 1
        default : // for recommanded calendars
            return recommandedEvents.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 : // for updated channels
            let cell = tableView.dequeueReusableCell(withIdentifier: channelsCellReuseIdentifier, for: indexPath) as! ChannelTableViewCell
            cell.channels = channels.map({ (title) -> Channel in
                Channel(title: title, thumbnail: #imageLiteral(resourceName: "channel"))
            })
            cell.allowsMultipleSelection = false
            cell.containerVC = self
            return cell
            
            
        default : // for recommanded calendars
            let cell = tableView.dequeueReusableCell(withIdentifier: calendarCellReuseIdentifier, for: indexPath) as! CalendarTableViewCell
            let event = recommandedEvents[indexPath.row]
            cell.eventNameLabel.text = event.title
            if let startDate = event.startDate {
                cell.startDateLabel.text = String(date: startDate)
            }
            if let endDate = event.endDate {
                cell.endDateLabel.text = String(date: endDate)
            }
            cell.locationLabel.text = String(locationList: event.locationList)
            
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

    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
