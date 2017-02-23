//
//  ScheduleCalendarViewCell.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 10..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import EventKit

let scheduleCalendarViewCellHeight: CGFloat = 85

class ScheduleCalendarViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var schedule: Schedule? {
        didSet {
            titleLabel.text = schedule?.name
            startLabel.text = schedule?.startedAt.toTimeString()
            endLabel.text = schedule?.endedAt.toTimeString()
            locationLabel.text = schedule?.location
            addButton.alpha = 1
            addButton.isHidden = schedule is UserSchedule
            
            
            UIView.animate(withDuration: 0.3, animations: {
                self.activityIndicator.stopAnimating()
                self.loadingView.alpha = 0
            }) { (success) in
                self.loadingView.isHidden = success
            }
        }
    }
    
    var isRecommanded: Bool {
        get {
            return self.schedule is RecommandedSchedule
        }
    }
    
    private let eventDC = EventDataController.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.layer.borderWidth = 0.1
        //self.layer.borderColor = UIColor.darkGray.cgColor
        self.activityIndicator.startAnimating()
    }
    
    @IBAction func addButtonTouchUpInside(_ sender: UIButton) {
        let eventStore = EventDataController.shared.eventStore
        
        guard let schedule = self.schedule else {
            print("NO Schedule Exists")
            return
        }
        
        let completion: ( (Bool, Error?, EKEvent?) -> Void) = { (success, error, event) in
            if success {
                print("Successfully Saved Event From Schedule: \(schedule.name)")
                
                UIView.animate(withDuration: 0.2, animations: { 
                    sender.alpha = 0
                }, completion: { (success) in
                    if success { sender.isHidden = true }
                })
                
                let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: (event?.startDate)!)
                let date = Calendar.current.date(from: dateComp)!
                
                
                let userSchedule = UserSchedule(ekEvent: event!)
                self.eventDC.userSchedules[date]?.append(userSchedule)
                
                let index = self.eventDC.recommandedSchedulesForDate[date]?.index(where: { (schedule) -> Bool in
                    return schedule.id == self.schedule?.id
                })
                self.eventDC.recommandedSchedulesForDate[date]?.remove(at: index!)
                
                self.schedule = userSchedule
            } else {
                print("failed to save event with error : \(error)")
            }
            
        }
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                if granted {
                    self.eventDC.createEvent(schedule: schedule, eventStore: eventStore, completion : completion)
                } else {
                    print("Request to Event Store Failed")
                }
            })
        } else {
            eventDC.createEvent(schedule: schedule, eventStore: eventStore, completion : completion)
        }

    }
}
