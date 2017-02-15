//
//  EventDataControllerEventDataController.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 9..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import Foundation
import EventKit

// singleton
// app Backend


class EventDataController {
    
    // Create the singleton instance
    static let shared: EventDataController = EventDataController()
    
    // Local Event Store
    private var eventStore: EKEventStore
    
    var userSchedules: Dictionary<Date, [UserSchedule]> = [:]
    var events: [Event] = []
    var schedules: [Schedule] = []
    
    // Prevent to create another EventDataController instance
    private init() {
        eventStore =  EKEventStore()
        eventStore.requestAccess(to: .event) { (isAllowed, error) in
            if error == nil && isAllowed {
                self.getLocalStoredSchedules()
                self.getEvents()
            }
        }
    }
    func getEvents() {
        self.events = createDummyEvents()
    }
    
    // MARK: - Event Data Load
    func getRecommandedEvents() -> [Event] {
        var events: [Event] = []
        
        // TODO : Get calendars from server. not from dummy
        events.append(contentsOf: createDummyEvents())
        
        return events
    }
    
    // MARK: Dummy Creator
    func createDummyEvents() -> [Event]{
        
        var dummyEvents: [Event] = [] // init calendar to return
        var titles = ["뮤란씨 물총축제", "부스트캠프 수료식", "프로젝트 데모데이", "맥북 증정식", "하이파트 눈썰매 축제", "가평 산천어 축제", "가나다날 개회식", "맥심 블로그 경진대회"]
        
        for i in 0..<8 {
            var schedules: [Schedule] = []
            schedules.append(createSchedule(title: titles[i] + "1", startDate: Date(string: "2016/11/26")!, endDate: Date(string: "2016/11/26")!, location: "서울 블루스퀘어 삼성전자홀"))
            schedules.append(createSchedule(title: titles[i] + "2", startDate: Date(string: "2017/03/12")!, endDate: Date(string: "2017/03/12")!, location: "서울 블루스퀘어 삼성전자홀"))
            schedules.append(RecommandedSchedule(name: "예시 스케쥴 3", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
            schedules.append(RecommandedSchedule(name: "예시 스케쥴 4", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
            schedules.append(RecommandedSchedule(name: "예시 스케쥴 5", location: "서울 블루스퀘어 삼성전자홀", startedAt: Date(string: "2016/11/27")!, endedAt: Date(string: "2016/11/27")!))
            let dummyEvent: Event = Event(title: titles[i], image: #imageLiteral(resourceName: "phantom"), schedules: schedules)
            dummyEvent.detail = "this is sample text for dummy. do not care so much. in working version, real data would be here."
            dummyEvents.append(dummyEvent)
            
            self.schedules.append(contentsOf: schedules)
        }
        
        return dummyEvents
    }
    
    func createSchedule(title: String, startDate: Date, endDate: Date, location: String) -> Schedule {
        let schedule = Schedule(id: 0, name: title, location: location, startedAt: startDate, endedAt: endDate)
        return schedule
    }

    
    // Returns Schedules converted from EKEvents saved in loacal Event Store
    func getLocalStoredSchedules() {
        let threeMonthAgo = Date(timeIntervalSinceNow: -3 * 30 * 24 * 3600)
        let threeMonthAfter = Date(timeIntervalSinceNow: +3 * 30 * 24 * 3600)
        print("Get Local Stored Scheduls from \(threeMonthAgo) to \(threeMonthAfter)")
        getLocalStoredSchedules(start: threeMonthAgo, end: threeMonthAfter)
    }
    
    func getLocalStoredSchedules(start: Date, end: Date) {
        let events: [EKEvent] = getLocalStoredEvents(start: start, end: end)
        for event in events {
            //print("Convert Event(id: \(event.eventIdentifier) name: \(event.title) to Schedule")
            // TODO :!!!!
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: event.startDate)
            let date = Calendar.current.date(from: dateComponents)!
            if var schedules = self.userSchedules[date] {
                schedules.append(UserSchedule(event))
            } else {
                self.userSchedules[event.startDate] = [UserSchedule(event)]
            }
        }
    }
    
    func getLocalStoredEvents(start: Date, end: Date) -> [EKEvent] {
        // TODO : 이미 저장된 것은 가져오지 않아야 하는데...
        // Use an event store instance to create and properly configure an NSPredicate
        let eventsPredicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: eventStore.calendars(for: .event))
        
        // Use the configured NSPredicate to find and return events in the store that match
        let events: [EKEvent] = eventStore.events(matching: eventsPredicate).sorted(){
            (e1: EKEvent, e2: EKEvent) -> Bool in
            return e1.compareStartDate(with: e2) == ComparisonResult.orderedAscending
        }
        
        return events
    }
    
    func getRecommanedSchedules(number: Int, for date: Date) -> [RecommandedSchedule] {
        // TODO : Real getter to be constucted, currently just dummy creator.
        var recommandedSchedules: [RecommandedSchedule] = []
        for count in 1..<number + 1 {
            let newSchedule = RecommandedSchedule(id: .dummy, name: "추천 일정 \(count)", location: "장소 \(count)",
                startedAt: date.addingTimeInterval( TimeInterval.hour * Double(count) ), endedAt: date.addingTimeInterval( TimeInterval.hour * Double(count + 1)))
            recommandedSchedules.append(newSchedule)
            
        }
        return recommandedSchedules
    }
}


// not used
class DataController {
    
    private var user: User?
    
    struct StaticInstance {
        static var instance: DataController?
    }
    
    class func sharedInstance() -> DataController {
        if !(StaticInstance.instance != nil) {
            StaticInstance.instance = DataController()
            // new member can be added here
            StaticInstance.instance?.user = User(id: 0)
            
        }
        
        return StaticInstance.instance!
    }
    
    // save or send func can be added (ex. Realm, firebaseDB)
    
    // functions to load data from local DB or networkDB
    
    // Or Network Controller can be divided from here DataController.
    
    // call function in View Controller on Network Call Completion
    
    // NSOperationQueue
}
