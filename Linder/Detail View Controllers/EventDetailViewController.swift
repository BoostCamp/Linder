//
//  EventDetailViewController.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 10..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

fileprivate let headerCellID = "headerCell"
fileprivate let detailCellID = "detailCell"
fileprivate let scheduleCellID = "scheduleCell"

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let eventDC = EventDataController.shared
    var eventID: Int64 = .empty
    var event: Event = Event()

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup table view
        self.tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: scheduleCellID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.estimatedRowHeight = 70
        tableView.allowsSelection = false
        
        // setup navigation bar
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.tintColor = .ldPuple
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.extendedLayoutIncludesOpaqueBars = true
        // Write view Title
        self.navigationItem.title = event.title
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set Status Bar Color
//        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//        statusBar?.backgroundColor = .ldPuple
//        applyTransparentBackgroundToTheNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        // tableView is shown below navigationBar
//        if let rect = self.navigationController?.navigationBar.frame {
//            let y = rect.origin.y
//            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationController?.navigationBar.barTintColor = .ldPuple
//        self.navigationController?.view.backgroundColor = .ldPuple
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // set Status Bar Color to default
//        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//        statusBar?.backgroundColor = .clear
        super.viewDidDisappear(animated)
    }
    
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
            let events = eventDC.events.filter({ (event) -> Bool in
                event.id == self.eventID
            })
            if let event = events.first {
                self.event = event
            }
            return event.schedules.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
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
            cell.schedule = self.event.schedules[indexPath.row]
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
        case IndexPath(row: 0, section: 0) : // for updated channels
            return EventHeaderTableViewCellHeight
        case IndexPath(row: 1, section: 0) :
            return UITableViewAutomaticDimension
        default : // for recommanded calendars
            return scheduleTableViewCellHeight
        }
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
