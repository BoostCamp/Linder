//
//  Schedule.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Linder. All rights reserved.
//


import Foundation
import EventKit

class Schedule {
    let id: Int64
    var name: String
    var location: String  = ""
    var startedAt: Date
    var endedAt: Date
    
    init(id: Int64, name: String, startedAt: Date, endedAt: Date, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.startedAt = startedAt
        self.endedAt = endedAt
    }
    
    init(id: Int64, name: String, location: String, startedAt: Date, endedAt: Date, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.location = location
        self.startedAt = startedAt
        self.endedAt = endedAt
    }
}

extension EKEvent {
    convenience init(schedule: Schedule) {
        self.init(eventStore: EKEventStore())
        self.title = schedule.name
        self.location = schedule.location
        self.startDate = schedule.startedAt
        self.endDate = schedule.endedAt
    }
}
