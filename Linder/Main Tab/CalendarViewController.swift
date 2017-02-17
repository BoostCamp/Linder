//
//  CalendarViewController.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 2. 9..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

fileprivate let scheduleCellID = "scheduleCell"
fileprivate let segueToEventDetail: String = "toEventDetail"

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // TODO : 추천 일정 등록하면 사용자 일정으로 변환.
    
    @IBOutlet weak var monthPicker: UIMonthPicker!
    @IBOutlet weak var monthButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let monthButtonTitlePostfix = "월 ▼"
    
    let numberOfRecommand = 2 // Temporary set to 0. Should be 2
    let eventDC = EventDataController.shared
    let today: Date = Date() // set today
    var month: DateComponents = Calendar.current.dateComponents([.year, .month], from: Date()) // set current month
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView Set
        self.tableView.register(UINib(nibName: "ScheduleCalendarViewCell", bundle: nil), forCellReuseIdentifier: scheduleCellID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // MonthButton setting
        monthUpdated()
        
        // Month Picker setting
        monthPicker.isHidden = true
        monthPicker.layer.borderWidth = 0.3
        monthPicker.layer.borderColor = UIColor.ldPuple.cgColor
        monthPicker.onDateSelected = { (month: Int, year: Int) in
            print("month: ", month)
            print("year: ", year)
            
            self.month = DateComponents(calendar: .current, year: year, month: month)
            self.monthUpdated()
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndex = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: selectedIndex)
            cell?.setSelected(false, animated: true)
        }
    }
    
    @IBAction func monthChange(_ sender: Any) {
        monthPicker.isHidden = !monthPicker.isHidden
    }
    
    func monthUpdated() {
        // MonthButton setting
        let formatter = DateFormatter()
        formatter.dateFormat = " M"  + monthButtonTitlePostfix
        let monthString = month.toDateString(formatter)
        self.monthButton.title = monthString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        //print(month.numberOfDaysInMonth())
        return month.numberOfDaysInMonth()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd EEE"
        let date = Calendar.current.date(byAdding: DateComponents(day: section), to: month.startDate)!
        return date.toDateString(formatter)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 그 날의 일정들의 개수..
        //스케쥴로 가져올 때의 접근 방법...
        let date = Calendar.current.date(byAdding: DateComponents(day: section), to: month.startDate)!
        //print(date)
        var numberOfSchedule = 0
        if let schedulesInTheDate = eventDC.userSchedules[date] {
            numberOfSchedule = schedulesInTheDate.count
        }
        //print("Number Of Schedule: ",numberOfSchedule)
        return numberOfSchedule + numberOfRecommand
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCellID, for: indexPath) as! ScheduleCalendarViewCell
        let date = Calendar.current.date(byAdding: DateComponents(day: indexPath.section), to: month.startDate)!
        
        if indexPath.row < numberOfRowsInSection - numberOfRecommand { // for user's local stored schedule
            if let local = eventDC.userSchedules[date]?[indexPath.row] {
                cell.schedule = local
            }
            return cell
        } else {
            // for recommanded schedule
            let recommandNumber = indexPath.row - numberOfRowsInSection + numberOfRecommand
            let schedule = eventDC.getRecommanedSchedules(number: numberOfRecommand, for: date)[recommandNumber]
            cell.schedule = schedule
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleCalendarViewCell
        if cell.schedule is RecommandedSchedule {
            performSegue(withIdentifier: segueToEventDetail, sender: self)
        } else {
            let ekEventVC = LDEventViewController()
            let userSchedule = cell.schedule as! UserSchedule
            ekEventVC.event = userSchedule.originalEKEvent
            ekEventVC.allowsCalendarPreview = true
            ekEventVC.allowsEditing = true
            
            ekEventVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(ekEventVC, animated: true)
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
        guard let segueID = segue.identifier else {
            return
        }
        switch segueID {
        case segueToEventDetail :
            let destinationVC = segue.destination as! EventDetailViewController
            let selectedCellIndex = self.tableView.indexPathForSelectedRow
            let selectedCell = self.tableView.cellForRow(at: selectedCellIndex!) as! ScheduleCalendarViewCell
            destinationVC.eventID = selectedCell.schedule?.eventID ?? .empty
        default:
            return
        }
    }
    

}
