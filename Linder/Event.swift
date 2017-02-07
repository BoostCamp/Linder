//
//  Event.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Linder. All rights reserved.
//


import UIKit
import EventKit

class Event {
    var title: String
    var thumbnail: UIImage?
    var schedules: [Schedule] = []
    var locationList: [String] {
        var tmpList: [String] = []
        for schedule in schedules {
            if schedule.location != "" {
                tmpList.append(schedule.location)
            }
        }
        return tmpList
    }
    
    var startDate: Date? {
        get {
            return schedules.first?.startedAt
        }
    }
    
    var endDate: Date? {
        get {
            return schedules.last?.endedAt
        }
    }
    
    init(title: String) {
        self.title = title
    }
    
    init(title: String, image: UIImage, schedules: [Schedule]) {
        self.title = title
        self.thumbnail = image
        self.schedules = schedules
    }
}

extension String {
    init(locationList: [String]) {
        let set = Set(locationList)
        let count = set.count
        switch count {
        case 0:
            self = ""
        case 1:
            self = set.first!
        default:
            self = set.first! + " 등 " + String(count - 1) + " 곳"
        }
    }
}
