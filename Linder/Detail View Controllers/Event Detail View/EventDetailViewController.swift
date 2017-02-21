//
//  EventDetailViewController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 10..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

fileprivate let headerCellID = "headerCell"
fileprivate let detailCellID = "detailCell"
fileprivate let scheduleCellID = "scheduleCell"

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // TODO : Schedule detail shoul be added !!
    // TODO : high light corresponding schedule !!
    @IBOutlet weak var tableView: UITableView!
    let eventDC = EventDataController.shared
    
    var event: Event = Event()
    
    var eventID: EventID {
        get {
            return self.event.id
        }
        set (new) {
            let events = eventDC.events.filter({ (event) -> Bool in
                event.id == new
            })
            if let event = events.first {
                self.event = event
            } else {
                eventDC.getEvents(withIDs: [new], completion: { (event) in
                    self.event = event  
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup table view
        self.tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: scheduleCellID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.estimatedRowHeight = scheduleCalendarViewCellHeight
        
        // setup navigation bar
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.tintColor = .ldPuple
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.extendedLayoutIncludesOpaqueBars = true
        // Write view Title
        self.navigationItem.title = event.title
        
    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//         set Status Bar Color
//        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//        statusBar?.backgroundColor = .ldPuple
//        applyTransparentBackgroundToTheNavigationBar()
//    }
//
//    override func viewDidLayoutSubviews() {
//        // tableView is shown below navigationBar
////        if let rect = self.navigationController?.navigationBar.frame {
////            let y = rect.origin.y
////            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
////        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
////        self.navigationController?.navigationBar.isTranslucent = false
////        self.navigationController?.navigationBar.tintColor = .white
////        self.navigationController?.navigationBar.barTintColor = .ldPuple
////        self.navigationController?.view.backgroundColor = .ldPuple
//        super.viewWillDisappear(animated)
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        // set Status Bar Color to default
////        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
////        statusBar?.backgroundColor = .clear
//        super.viewDidDisappear(animated)
//    }
//    
//    func applyTransparentBackgroundToTheNavigationBar(_ opacity: CGFloat = 0) {
//        var transparentBackground: UIImage
//        
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, navigationController!.navigationBar.layer.contentsScale)
//        let context = UIGraphicsGetCurrentContext()!
//        context.setFillColor(red: 1, green: 1, blue: 1, alpha: opacity)
//        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
//        transparentBackground = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        let navigationBarAppearance = self.navigationController!.navigationBar
//        
//        navigationBarAppearance.setBackgroundImage(transparentBackground, for: .default)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // 1: header and detail of event // 2: schedule cells
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return event.scheduleIDs.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case IndexPath(row: 0, section: 0): // Event Header
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellID, for: indexPath) as! EventHeaderTableViewCell
            // Configure the cell...
            cell.event = self.event
            return cell
        case IndexPath(row: 1, section: 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: detailCellID, for: indexPath) as! EventDetailTableViewCell
            // Configure the cell...
            cell.textView.delegate = self
            cell.textView.text = self.event.detail
            return cell
        // For schedule cells in section 1
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCellID, for: indexPath) as! ScheduleTableViewCell
            // Configure the cell...
            eventDC.getSchedule(withID: self.event.scheduleIDs[indexPath.row]) { (schedule) in
                cell.schedule = schedule
            }
            return cell
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
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0) : // for Event imager
            return EventHeaderTableViewCellHeight
        case IndexPath(row: 1, section: 0) : // for Event Detail
            return UITableViewAutomaticDimension
        default : // for recommanded Schedule
            if indexPath == tableView.indexPathForSelectedRow {
                return UITableViewAutomaticDimension
            }
            return scheduleCalendarViewCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section != 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleTableViewCell
        cell.tableViewCell.backgroundColor = UIColor.lightGray
        cell.flipIndicator()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.delegate?.tableView!(tableView, didDeselectRowAt: indexPath)
                return nil
            }
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleTableViewCell
        cell.tableViewCell.backgroundColor = UIColor.groupTableViewBackground
        cell.flipIndicator()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    

            

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}

extension EventDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
