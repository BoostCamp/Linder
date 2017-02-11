//
//  DataController.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 8..
//  Copyright © 2017년 Linder. All rights reserved.
//

import Foundation

// singleton
// app Backend
class DataController {
    var user : User?
    
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
