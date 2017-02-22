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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.layer.borderWidth = 0.1
        //self.layer.borderColor = UIColor.darkGray.cgColor
        self.activityIndicator.startAnimating()
    }
    
    @IBAction func addButtonTouchUpInside(_ sender: UIButton) {
        sender.isHighlighted = true
        debugPrint("TODO : Add to User's Local Calendar")
        
        let eventStore = EventDataController.shared.eventStore
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                if granted {
                    self.createEvent(eventStore)
                } else {
                    print("Request to Event Store Failed")
                }
            })
        } else {
            self.createEvent(eventStore)
        }

    }
    
    private func createEvent(_ eventStore: EKEventStore) {
        guard let schedule = self.schedule else {
            print("NO Schedule Exists")
            return
        }
        
        let event = EKEvent(schedule: schedule, eventStore: eventStore)
        
        do {
            try eventStore.save(event, span: .thisEvent)
            print("Saved Event")
            print(event)
        } catch let error as NSError {
            print("failed to save event with error : \(error)")
        }
    }
}
