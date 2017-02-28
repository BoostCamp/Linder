//
//  CalendarViewController.swift
//  Lindar
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
    @IBOutlet weak var maskingView: UIView!
    
    let monthButtonTitlePostfix = "월 ▼"
    
    let maxNumberOfRecommand = 2 // Temporary set to 0. Should be 2
    let eventDC = EventDataController.shared
    let today: Date = Date() // set today
    var month: DateComponents = Calendar.current.dateComponents([.year, .month], from: Date()) // set current month
    
    let animationDuration = 0.2
    
    var allSchedules: [Date : [Schedule]] = [:]
    var keysFilled: [Date] = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!) // not required when using UITableViewController
        
        
        // View Layout set
        self.extendedLayoutIncludesOpaqueBars = true
        
        // tableView Set
        self.tableView.register(UINib(nibName: "ScheduleCalendarViewCell", bundle: nil), forCellReuseIdentifier: scheduleCellID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Month Picker setting
        monthPicker.isHidden = true
        monthPicker.layer.borderWidth = 0.3
        monthPicker.layer.borderColor = UIColor.ldPuple.cgColor
        monthPicker.onDateSelected = { (month: Int, year: Int) in
            self.keysFilled = []
            self.allSchedules = [:]
            self.month = DateComponents(calendar: .current, year: year, month: month)
            self.monthUpdated()
        }
        
        self.maskingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideMonthPicker)))
        maskingView.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndex = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: selectedIndex) as! ScheduleCalendarViewCell
            cell.setSelected(false, animated: true)
            
            //let date = Calendar.current.date(byAdding: DateComponents(day: selectedIndex.section), to: month.startDate)!
            let date = keysFilled[selectedIndex.section]
            cell.schedule = eventDC.userSchedules[date]?[selectedIndex.row]
            
        }

        
        // MonthButton setting
        monthUpdated()
        
        self.tableView.reloadData()

    }
    
    @IBAction func monthChange(_ sender: Any) {
        let width = self.view.frame.width * (2/3)
        let height = width * (3/4)
        if monthPicker.isHidden {
            monthPicker.isHidden = false
            monthPicker.frame.size = CGSize.zero
            UIView.animate(withDuration: animationDuration, animations: { 
                self.monthPicker.frame.size = CGSize(width: width, height: height)
            })
            maskingView.isHidden = false
        } else {
            hideMonthPicker()
        }
        monthUpdated()
        
    }
    
    func hideMonthPicker() {
        if !monthPicker.isHidden {
            UIView.animate(withDuration: animationDuration, animations: {
                self.monthPicker.frame.size = CGSize.zero
            }, completion: { (success) in
                self.monthPicker.isHidden = true
            })
        }
        maskingView.isHidden = true
    }
    
    func monthUpdated() {
        // MonthButton setting
        print("month update")
        let formatter = DateFormatter()
        formatter.dateFormat = " M"  + monthButtonTitlePostfix
        let monthString = month.toDateString(formatter)
        self.monthButton.title = monthString
        
        for day in 0..<month.numberOfDaysInMonth() {
            let date = Calendar.current.date(byAdding: DateComponents(day: day), to: month.startDate)!
            updateScheduleFor(date: date)
        }
        self.tableView.reloadData()
    }
    
    func updateScheduleFor(date: Date) {
        allSchedules.updateValue(eventDC.userSchedules[date] ?? [], forKey: date)
        print("date",date)
        if self.eventDC.recommandedSchedulesForDate[date] == nil || self.eventDC.recommandedSchedulesForDate[date]?.count == 0{
            self.eventDC.recommandedSchedulesForDate[date] = []
            eventDC.getRecommanedSchedules(maxNumber: maxNumberOfRecommand, for: date) { (recommandation) in
                self.eventDC.recommandedSchedulesForDate[date]?.append(recommandation)
                self.allSchedules[date]!.append(recommandation)

                
                let keys = Array(self.allSchedules.keys).sorted(by: { (left, right) -> Bool in
                    return left.compare(right) == .orderedAscending
                })
                self.keysFilled = keys.filter { (date) -> Bool in
                    guard let schedulesInDate = self.allSchedules[date] else {
                        return false
                    }
                    return schedulesInDate.count > 0
                }
                self.tableView.reloadData()
            }
        } else {
            self.allSchedules[date]!.append(contentsOf: self.eventDC.recommandedSchedulesForDate[date]!)
            
        }
        //if allSchedules[date]!.count == 0 { allSchedules[date] = nil }
        
        let keys = Array(self.allSchedules.keys).sorted(by: { (left, right) -> Bool in
            return left.compare(right) == .orderedAscending
        })
        self.keysFilled = keys.filter { (date) -> Bool in
            guard let schedulesInDate = self.allSchedules[date] else {
                return false
            }
            return schedulesInDate.count > 0
        }
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return keysFilled.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: section)
//        if numberOfRows == 0 {
//            return 0.001
//        }
        return 25
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd EEE"

        let date = keysFilled[section]
        return date.toDateString(formatter)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let date = keysFilled[section]
        
        var numberOfSchedule = 0
        
        if let schedulesInTheDate = eventDC.userSchedules[date] {
            numberOfSchedule = schedulesInTheDate.count
        }
        
        return numberOfSchedule + (eventDC.recommandedSchedulesForDate[date]?.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCellID, for: indexPath) as! ScheduleCalendarViewCell
        //let date = Calendar.current.date(byAdding: DateComponents(day: indexPath.section), to: month.startDate)!
        let date = keysFilled[indexPath.section]
        cell.isSelected = false
        
        if indexPath.row < (eventDC.userSchedules[date]?.count ?? 0) { // for user's local stored schedule
            if let local = eventDC.userSchedules[date]?[indexPath.row] {
                cell.schedule = local
            }
            return cell
        } else {
            // for recommanded schedule
            let recommandNumber = indexPath.row - (eventDC.userSchedules[date]?.count ?? 0)
            let schedule = eventDC.recommandedSchedulesForDate[date]?[recommandNumber]
            cell.schedule = schedule
            return cell
        }
    }
    
    // MARK: - Table View Delegate
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleCalendarViewCell
        if cell.schedule is RecommandedSchedule {
            performSegue(withIdentifier: segueToEventDetail, sender: self)
        } else {
            let ekEventVC = LDEventViewController()
            let userSchedule = cell.schedule as! UserSchedule
            ekEventVC.event = userSchedule.originalEKEvent
            ekEventVC.allowsCalendarPreview = false  // Bug Maker
            ekEventVC.allowsEditing = true
            ekEventVC.delegate = self
            ekEventVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(ekEventVC, animated: true)
        }
    }
    
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

extension CalendarViewController: EKEventViewDelegate {
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        let event = controller.event
        let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: event.startDate)
        let date = Calendar.current.date(from: dateComp)!
        
        guard let section = keysFilled.index(of: date) else {
            print("Invalid Secion - Date")
            return
        }
        guard let row = eventDC.userSchedules[date]?.index(where: { (userSchedule) -> Bool in
            return userSchedule.originalEKEvent == event
        }) else {
            print("There is not Such EKEvent")
            return
        }
        
        let indexPath = IndexPath(row: row, section: section)
        
        switch action {
        case .deleted:
            print("Eventt Deleted")
            let _ = controller.navigationController?.popViewController(animated: true)
            eventDC.userSchedules[date]?.remove(at: row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            //self.tableView.reloadSections([section], with: .fade)
            self.tableView.endUpdates()
            //self.updateScheduleFor(date: date)
            self.tableView.reloadData()
            
            
        default:
            print("Eventt Not Deleted")
        }
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        eventDC.eventStore.requestAccess(to: .event) { (isAllowed, error) in
            if error == nil && isAllowed {
                self.eventDC.userSchedules = [:]
                self.eventDC.getLocalStoredSchedules()
                self.monthUpdated()
                self.tableView.reloadData()
            }
        }
        
        self.refreshControl?.endRefreshing()
    }
}
