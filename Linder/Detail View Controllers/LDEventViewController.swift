//
//  LDEventViewController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 11..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import EventKitUI

class LDEventViewController: EKEventViewController {

    override func viewDidLoad() {
        self.navigationController?.view.backgroundColor = .white
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.bottom
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
        super.viewWillDisappear(animated)
        
        let eventDC = EventDataController.shared
        
        let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: event.startDate)
        let date = Calendar.current.date(from: dateComp)!
        
        let section = dateComp.day! - 1
        guard let row = eventDC.userSchedules[date]?.index(where: { (userSchedule) -> Bool in
            return userSchedule.originalEKEvent == event
        }) else {
            print("There is not Such EKEvent")
            return
        }
        
        let indexPath = IndexPath(row: row, section: section)
        
        
        eventDC.userSchedules[date]?[row] = UserSchedule(ekEvent: event)
    }
    
}
