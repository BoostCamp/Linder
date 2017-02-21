//
//  Event.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 31..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import EventKit

typealias EventID = Int64

class Event {
    var id: EventID = .empty
    var title: String
    var thumbnailURL: URL?
    var scheduleIDs: [ScheduleID] = []
    var detail: String = ""
    var updatedAt: Date = Date()
    var participantCount: Int = 0
    
    var locations: [String] = []
    
//    var locationList: [String] {
//        var tmpList: [String] = []
//        for scheduleID in scheduleIDs {
//            
//            if schedule.location != "" {
//                tmpList.append(schedule.location)
//            }
//        }
//        return tmpList
//    }

    var startedAt: Date?
//    var startDate: Date? {
//        get {
//            let sorted: [Schedule] = schedules.sorted { (former, later) -> Bool in
//                return former.startedAt < later.startedAt
//            }
//            return sorted.first?.startedAt
//        }
//    }
    
    var endedAt: Date?
//    var endDate: Date? {
//        get {
//            let sorted: [Schedule] = schedules.sorted { (former, later) -> Bool in
//                return former.endedAt < later.endedAt
//            }
//            return sorted.last?.endedAt
//        }
//    }
    
    // dummy Event
    convenience init() {
        var schedules: [Schedule] = []
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 1", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/26")!, endedAt: Date(string: "2016/11/26")!))
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 2", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 3", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 4", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 5", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
        
        self.init(title: "예시 이벤트", thumbnailURL: URL(string: "http://dimg.donga.com/wps/NEWS/IMAGE/2015/04/30/70995253.1.jpg")!, scheduleIDs: [1,2])
        self.detail = "this is sameple text \n http://www.naver.com"
    }

    init(title: String) {
        self.title = title
    }
    
    init(title: String, thumbnailURL: URL, scheduleIDs: [ScheduleID]) {
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.scheduleIDs = scheduleIDs
    }
    
    init(id: Int64, title: String, thumbnailURL: URL, scheduleIDs: [ScheduleID], detail: String, locations: [String], startedAt: Date, endedAt: Date) {
        self.id = id
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.scheduleIDs = scheduleIDs
        self.detail = detail
        self.locations = locations
        self.startedAt = startedAt
        self.endedAt = endedAt
    }
    
}

extension String {
    init?(locationList: [String]?) {
        guard let locations = locationList else {
            return nil
        }
        let set = Set(locations)
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
