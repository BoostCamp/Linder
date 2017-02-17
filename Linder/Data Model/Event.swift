//
//  Event.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 31..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import EventKit

class Event {
    var id: Int64 = .empty
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
    var detail: String = ""
    var updatedAt: Date = Date()
    var participantCount: Int = 0
    
    var startDate: Date? {
        get {
            let sorted: [Schedule] = schedules.sorted { (former, later) -> Bool in
                return former.startedAt < later.startedAt
            }
            return sorted.first?.startedAt
        }
    }
    
    var endDate: Date? {
        get {
            let sorted: [Schedule] = schedules.sorted { (former, later) -> Bool in
                return former.endedAt < later.endedAt
            }
            return sorted.last?.endedAt
        }
    }
    
    // dummy Event
    convenience init() {
        var schedules: [Schedule] = []
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 1", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/26")!, endedAt: Date(string: "2016/11/26")!))
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 2", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 3", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 4", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
        schedules.append(RecommandedSchedule(name: "예시 스케쥴 5", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
        self.init(title: "예시 이벤트", image: #imageLiteral(resourceName: "phantom"), schedules: schedules)
        self.detail = "this is sameple text \n http://www.naver.com"
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
