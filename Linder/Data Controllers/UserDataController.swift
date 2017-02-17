//
//  UserDataController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 13..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum UserDataType: String {
    case age = "age"
    case gender = "gender"
}

enum Followable: String {
    case hashtags = "hashtags"
    case channels = "channels"
}

class UserDataController {
    
    // Create the singleton instance
    static let shared: UserDataController = UserDataController()
    
    var user: User
    
    // Prevent to create another UserDataController instance
    private init() {
        self.user = User()
    }
    
    // MARK - Alamofire put
    func putUserData(type: UserDataType, data: String) {
        // get current User ID
        let userID = self.user.id
        guard let accessToken = self.user.accessToken else {
            debugPrint("No Access Token exist")
            // TODO : PopUP Login
            return
        }
        
        let path = URL(string: baseURL + "users/" + String(userID))!
        
        let body: Parameters = [ type.rawValue : data ]
        
        let sessionManager = SessionManager()
        sessionManager.adapter = AccessTokenAdapter(accessToken: accessToken)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + accessToken,
            "Content-Type": "application/json"
        ]
        // TODO : generator header
        // TODO : every elements in body
        Alamofire.request(path, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().responseJSON(completionHandler: { (response) in
            //sessionManager.request(path, method: .put, parameters: body, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { (response) in
            print("Header: ")
            print(JSON(response.request?.allHTTPHeaderFields ?? [:]))
            switch response.result {
            case .success(let value) :
                // get userId from json
                let valueJSON = JSON(value)
                let dataJSON = valueJSON["data"]
                // set user Data from json to AppDelegate's User property
                self.user.gender = Gender(rawValue: dataJSON["gender"].intValue)!
                
                let age: Int = Int(dataJSON["age"].intValue/10) * 10
                self.user.age = Age(rawValue: age)!
                
                switch type {
                case .age :
                    print("User Age: " , self.user.age)
                case .gender:
                    print("User Gender: " , self.user.gender)
                }
                
            case .failure :
                debugPrint("Response:")
                debugPrint(response)
                // TODO : catch error
                // TODO : add retry task using saved body to task queue
                print("You Must Re-select gender and age")
            }
        })
    }
    
    func follow(channel: Channel) {
        let contains = user.channels.contains(where: { (channelItem: Channel) -> Bool in
            return channelItem.id == channel.id
        })
        if contains {
            user.channels.append(channel)
        }
    }
    
    func follow(followable: Followable, data: String) {
        // get current User ID
        //        let userID = self.id
        //        guard let accessToken = self.accessToken else {
        //            debugPrint("No Access Token exist")
        //            // TODO : PopUP Login
        //            return
        //        }
        return
        //
        //        let path = URL(string: baseURL + "users/" + String(userID))!
        //
        //        let body: Parameters = [ type.rawValue : data ]
        //
        //        let sessionManager = SessionManager()
        //        sessionManager.adapter = AccessTokenAdapter(accessToken: accessToken)
        //
        //        let headers: HTTPHeaders = [
        //            "Authorization": "Bearer " + accessToken,
        //            "Content-Type": "application/json"
        //        ]
        //        // TODO : generator header
        //        // TODO : every elements in body
        //        Alamofire.request(path, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().responseJSON(completionHandler: { (response) in
        //            //sessionManager.request(path, method: .put, parameters: body, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { (response) in
        //            print("Header: ")
        //            print(JSON(response.request?.allHTTPHeaderFields ?? [:]))
        //            switch response.result {
        //            case .success(let value) :
        //                // get userId from json
        //                let valueJSON = JSON(value)
        //                let dataJSON = valueJSON["data"]
        //                // set user Data from json to AppDelegate's User property
        //                self.gender = Gender(rawValue: dataJSON["gender"].intValue)!
        //
        //                let age: Int = Int(dataJSON["age"].intValue/10) * 10
        //                self.age = Age(rawValue: age)!
        //
        //                switch type {
        //                case .age :
        //                    print("User Age: " , self.age)
        //                case .gender:
        //                    print("User Gender: " , self.gender)
        //                default :
        //                    print("Not Handled User Data Type")
        //                }
        //
        //            case .failure :
        //                debugPrint("Response:")
        //                debugPrint(response)
        //                // TODO : catch error
        //                // TODO : add retry task using saved body to task queue
        //                print("You Must Re-select gender and age")
        //            }
        //        })
    }
    
    func unFollow(followable: Followable, data: String) {
        return
    }
    
    func setRegion(regionName: String) {
        // TODO : Find regionID
        // TODO : Put or post regionID to server
        debugPrint("Set \(regionName)")
    }
    
    func setRegion(lat: Float, lng: Float) -> Void {
        // TODO : Put or post latlng to server
    }
}
