//
//  EventDataControllerEventDataController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 9..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import Foundation
import EventKit
import Firebase
import FirebaseDatabase

// singleton
// app Backend
enum ChannelScope {
    case all, following
}


class EventDataController {
    
    // Create the singleton instance
    static let shared: EventDataController = EventDataController()
    
    // Firebase database reference
    let ref: FIRDatabaseReference
    
    // Local Event Store
    var eventStore: EKEventStore
    private var user = UserDataController.shared.user
    
    var events: [Event] = []
    var recommandedEvents: [Event] = []
    var userSchedules: Dictionary<Date, [UserSchedule]> = [:]
    var recommandedSchedulesForDate: [Date:[RecommandedSchedule]] = [:]
    var schedules: [Schedule] = []
    
    // Prevent to create another EventDataController instance
    private init() {
        // Use Firebase library to configure APIs
        FIRApp.configure()
        // [START create_database_reference]
        ref = FIRDatabase.database().reference()
        // [END create_database_reference]
        
        
        // Get User Schedules
        eventStore =  EKEventStore()
        
        eventStore.requestAccess(to: .event) { (isAllowed, error) in
            if error == nil && isAllowed {
                self.getLocalStoredSchedules()
            }
        }
    }
    
    // MARK: - Event Data Load
    // Major Functions
    
    // if ids == nil, get all events
    
    func getEvents(withIDs ids: [EventID]? = nil, from: UInt = 1, count: UInt = 10, completion: @escaping (Event) -> Void) {
        self.getFIREvents(withIDs: ids, completion: completion)
        //return createDummyEvents()
    }
    
    func getRecommandedEvents(completion: @escaping (Event) -> Void) {
        // TODO : Get calendars from server. not from dummy
        //self.recommanedEvents.append(contentsOf: createDummyEvents())
        self.getFIRRecommandedEvents(completion: completion)
    }
    
    func getSchedule(withID: ScheduleID, completion: @escaping (Schedule) -> Void) {
        getFIRSchdule(withID: withID, completion: completion)
    }
    
    func searchSchedules(withKeyword keyword: String, completion: @escaping ([Schedule]) -> Void) {
        self.searchFIRSchedules(withKeyword: keyword, completion: completion)
    }
    
    func getChannels(scope: ChannelScope, count: UInt = 20, completion: @escaping (Channel) -> Void) {
        self.getFIRChannels(scope: scope, count: count, completion: completion)
    }
    
    
    // MARK: - FIRBASE DB SET
    
    // FireBase DB setup
    func setFIRDB() {
        setFIREvents()
        setFIRChannels()
    }
    
    private func setFIREvents() {
        
    }
    
    private func setFIRSchedules() {
        
    }
    
    private func setFIRChannels() {
    }
    
    // MARK: - FIRBASE DB Get
    private func getFIRChannels(scope: ChannelScope, count: UInt = 20, completion: @escaping (Channel) -> Void) {
        print("getFIRChannels")
        let channelRef =  self.ref.child("channels").queryOrdered(byChild: "updatedAt")
        let queryType = FIRDataEventType.childAdded
        
        var cnt: UInt = 0

        channelRef.observe(queryType, with: { (snapshot) in
            //print("DUMP:")
            //dump(snapshot)
            guard let channelID = ChannelID(snapshot.key) else {
                print("Error: No or Invalide Channel ID")
                return
            }
            
            // Check this channel is in search scope
            guard scope == .all || self.user.channelIDs.contains(channelID) else {
                return
            }
            
            guard let value = snapshot.value as? [String: AnyObject] else {
                print("Error: NO Data")
                return
            }
            
            guard let eventIDs = value["events"] as? [EventID] else {
                print("Error: No or Invalide Event IDs")
                  return
            }
            
            // pars Date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            guard let updatedAtString = value["updatedAt"] as? String else {
                print("ERROR: Cannot Pars End Date of Channel ID: \(snapshot.key).")
                return
            }
            
            guard let hashtag = value["hashtag"] as? String else {
                print("ERROR: Cannot Pars hashtag of Channel ID: \(snapshot.key).")
                return
            }
            
            let channel = Channel(id: channelID,
                                  title: value["title"] as! String,
                                  thumbnailURL: URL(string: value["thumbnail"] as! String)!,
                                  hashtags: [hashtag],
                                  eventIDs: eventIDs,
                                  updatedAt: Date(string: updatedAtString, formatter: formatter)!)
            completion(channel)
            
            cnt += 1
            if cnt >= count {
                channelRef.removeAllObservers()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getFIREvents(withIDs ids: [EventID]? = nil, completion: @escaping (Event) -> Void){
        let eventsRef =  self.ref.child("events")
        var type = FIRDataEventType.childAdded
        
        let newCompletion: ((Event) -> Void) = { (event) in
            self.events.append(event)
            completion(event)
        }
        
        if let idArray = ids {
            for id in idArray {
                let eventRef = eventsRef.child("\(id)")
                type = FIRDataEventType.value
                self.observeFIREvent(reference: eventRef, type: type, completion: newCompletion)
            }
        } else {
            self.observeFIREvent(reference: eventsRef, type: type, completion: newCompletion)
        }
        
    }
    
    private func observeFIREvent(reference: FIRDatabaseReference, type: FIRDataEventType, completion: @escaping (Event) -> Void) {
        reference.observe(type, with: { (snapshot) in
            //print("DUMP:")
            //dump(snapshot)
            guard let value = snapshot.value as? [String: AnyObject] else {
                print("Error: NO Data")
                return
            }
            
            guard let scheduleIDs = value["schedules"] as? [Int64] else {
                print("Error: No or Invalide Schedule IDs")
                return
            }
            
            // pars Date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            guard let startedAtString = value["startedAt"] as? String else {
                print("ERROR: Cannot Pars Start Date of Event ID: \(snapshot.key).")
                return
            }
            
            guard let endedAtString = value["endedAt"] as? String else {
                print("ERROR: Cannot Pars End Date of Event ID: \(snapshot.key).")
                return
            }
            
            let event = Event(id: Int64(snapshot.key)!,
                              title: value["title"] as! String,
                              thumbnailURL: URL(string: value["thumbnail"] as! String)!,
                              scheduleIDs: Array(scheduleIDs),
                              detail: value["detail"] as! String,
                              locations: value["locations"] as! [String],
                              startedAt: Date(string: startedAtString, formatter: formatter)!,
                              endedAt: Date(string: endedAtString, formatter: formatter)!)
            completion(event)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getFIRRecommandedEvents(completion: @escaping (Event) -> Void) {
        let eventsRef =  self.ref.child("events")
        let type = FIRDataEventType.childAdded
        let newCompletion: ( (Event) -> Void ) = { (event) in
            self.recommandedEvents.append(event)
            completion(event)
        }
        self.observeFIREvent(reference: eventsRef, type: type, completion: newCompletion)
    }
    
    private func getFIRSchdule(withID id: ScheduleID, completion: @escaping (Schedule) -> Void) {
        
        let schedulesRef =  self.ref.child("schedules").child("\(id)")
        
        schedulesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //debugPrint("DUMP:")
            //dump(snapshot)
            
            let id = Int64(snapshot.key)!
            
            guard let value = snapshot.value as? NSDictionary else {
                print("ERROR: Failed to Load Request Schedule with id : \(id). Please Check the DB has Requested Schedule.")
                return
            }
            let name = value["name"] as! String
            guard let location = value["location"] as? String else {
                print("ERROR: Cannot Pars Location of Schedule ID: \(snapshot.key).")
                return
            }
            
            // pars Date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            guard let startedAtString = value["startedAt"] as? String else {
                print("ERROR: Cannot Pars Start Date of Schedule ID: \(snapshot.key).")
                return
            }
            
            guard let endedAtString = value["endedAt"] as? String else {
                print("ERROR: Cannot Pars End Date of Schedule ID: \(snapshot.key).")
                return
            }
            
            let startedAt = Date(string: startedAtString, formatter: formatter)!
            
            let endedAt = Date(string: endedAtString, formatter: formatter)!
            
            let detail = value["detail"] as! String
            
            let schedule = RecommandedSchedule(id: id,
                                           name: name,
                                           location: location,
                                           startedAt: startedAt,
                                           endedAt: endedAt,
                                           detail: detail)
            if let eventID = value["eventId"] as? EventID {
                schedule.eventID = eventID
            }
            
            completion(schedule)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
//    
//    private func getFIRSchdules(withIDs ids: [ScheduleID]) -> [RecommandedSchedule] {
//        var schedules: [RecommandedSchedule] = []
//        
//        let schedulesRef =  self.ref.child("schedules")
//        // TODO filter using parameter id
//        
//        schedulesRef.observe(.childAdded, with: { (snapshot) in
//            dump(snapshot)
//            guard let value = snapshot.value as? NSDictionary else {
//                print("ERROR: Failed to Load Request Schedule with id : \(ids). Please Check the DB has Requested Schedule.")
//                return
//            }
//            
//            // pars Date
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm"
//            
//            guard let startedAtString = value["startedAt"] as? String else {
//                print("ERROR: Cannot Pars Start Date of Schedule ID: \(snapshot.key).")
//                return
//            }
//            
//            guard let endedAtString = value["endedAt"] as? String else {
//                print("ERROR: Cannot Pars End Date of Schedule ID: \(snapshot.key).")
//                return
//            }
//            
//            let schedule = RecommandedSchedule(id: Int64(snapshot.key)!,
//                                           name: value["name"] as! String,
//                                           location: value["location"] as! String,
//                                           startedAt: Date.init(string: startedAtString, formatter: formatter)!,
//                                           endedAt: Date.init(string: endedAtString, formatter: formatter)!)
//            schedules.append(schedule)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//        return schedules
//    }
    
    private func searchFIRSchedules(withKeyword keyword: String, completion: @escaping ([Schedule]) -> Void) {
        var schedules: [Schedule] = []
        
        let schedulesRef =  self.ref.child("schedules").queryOrdered(byChild: "name").queryStarting(atValue: keyword).queryEnding(atValue: keyword+"\u{f8ff}")
        schedulesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            debugPrint("snapShot")
//            dump(snapshot)
            
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                guard let value = rest.value as? NSDictionary else {
                    print("ERROR: Failed to Load Request Schedule with Keyword : \(keyword). Please Check the DB has Requested Schedule.")
                    return
                }
                // pars Date
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                guard let startedAtString = value["startedAt"] as? String else {
                    print("ERROR: Cannot Pars Start Date of Schedule ID: \(rest.key).")
                    return
                }
                
                guard let endedAtString = value["endedAt"] as? String else {
                    print("ERROR: Cannot Pars End Date of Schedule ID: \(rest.key).")
                    return
                }
                
                let schedule = RecommandedSchedule(id: Int64(rest.key)!,
                                                   name: value["name"] as! String,
                                                   location: value["location"] as! String,
                                                   startedAt: Date.init(string: startedAtString, formatter: formatter)!,
                                                   endedAt: Date.init(string: endedAtString, formatter: formatter)!)
                if let eventID = value["eventId"] as? EventID {
                    schedule.eventID = eventID
                }
                
                schedules.append(schedule)
            }
            completion(schedules)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    // Returns Schedules converted from EKEvents saved in loacal Event Store
    func getLocalStoredSchedules() {
        let threeMonthAgo = Date(timeIntervalSinceNow: -3 * 30 * 24 * 3600)
        let threeMonthAfter = Date(timeIntervalSinceNow: +3 * 30 * 24 * 3600)
        //debugPrint("Get Local Stored Scheduls from \(threeMonthAgo) to \(threeMonthAfter)")
        getLocalStoredSchedules(start: threeMonthAgo, end: threeMonthAfter)
    }
    
    func getLocalStoredSchedules(start: Date, end: Date) {
        let events: [EKEvent] = getLocalStoredEvents(start: start, end: end)
        for event in events {
            // TODO : Using dictionary? resolve timing issue..
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: event.startDate)
            let date = Calendar.current.date(from: dateComponents)!
            //print("Write User Schedule name: \(event.title) at \(date)")
            if var schedules = self.userSchedules[date] {
                schedules.append(UserSchedule(ekEvent: event))
            } else {
                self.userSchedules[date] = [UserSchedule(ekEvent: event)]
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
    
    func getRecommanedSchedules(maxNumber max: Int, for date: Date, completion: @escaping (RecommandedSchedule) -> Void ) {
        getFIRRecommanedSchedules(maxNumber: max, for: date, completion: completion)
    }
    
    func getFIRRecommanedSchedules(maxNumber max: Int, for date: Date, completion:  @escaping (RecommandedSchedule) -> Void ) {
        var count = 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: date)
        
        let nextDate = date.addingTimeInterval(24 * 60 * 60)
        let nextDateString = formatter.string(from: nextDate)
        
        let schedulesRef =  self.ref.child("schedules").queryOrdered(byChild: "startedAt").queryStarting(atValue: dateString).queryEnding(atValue: nextDateString)
        schedulesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //debugPrint("snapShot for \(dateString)")
            //dump(snapshot)
            
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot, (count < max) {
                guard let value = rest.value as? NSDictionary else {
                    print("ERROR: Failed to Load Request Schedule at \(dateString). Please Check the DB has Requested Schedule.")
                    return
                }
                // pars Date
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                guard let startedAtString = value["startedAt"] as? String else {
                    print("ERROR: Cannot Pars Start Date of Schedule ID: \(rest.key).")
                    return
                }
                
                guard let endedAtString = value["endedAt"] as? String else {
                    print("ERROR: Cannot Pars End Date of Schedule ID: \(rest.key).")
                    return
                }
                
                let schedule = RecommandedSchedule(id: Int64(rest.key)!,
                                                   name: value["name"] as! String,
                                                   location: value["location"] as! String,
                                                   startedAt: Date.init(string: startedAtString, formatter: formatter)!,
                                                   endedAt: Date.init(string: endedAtString, formatter: formatter)!)
                
                if let eventID = value["eventId"] as? Int {
                    schedule.eventID = EventID(eventID)
                }
                
                count += 1
                completion(schedule)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
            let dummyEvent: Event = Event(title: titles[i],
                                          thumbnailURL: URL(string: "http://dimg.donga.com/wps/NEWS/IMAGE/2015/04/30/70995253.1.jpg")!,
                                          scheduleIDs: [1,2]) // TODO : Schedule ID !!!
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
    
    func createEvent(schedule: Schedule, eventStore: EKEventStore, completion: (Bool, Error?, EKEvent?) -> Void) {
        let event = EKEvent(schedule: schedule, eventStore: eventStore)
        
        do {
            try eventStore.save(event, span: .thisEvent)
            completion(true, nil, event)
        } catch let error {
            completion(false, error, nil)
        }
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
