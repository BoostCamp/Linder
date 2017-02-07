//
//  User.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Linder. All rights reserved.
//


import Foundation

typealias UserID = Int64
typealias Hashtag = String

class User {
    var id: UserID
    var hashtags: [Hashtag] = []
    var channels: [Channel] = []
    
    init() { // Guest User Creation
        self.id = -1
    }
    
    init(id: Int64) {
        self.id = id
    }
    
    func follow(channel: Channel, data: String) {
        return
    }
    
    func unFollow(channel: Channel, data: String) {
        return
    }
    
    func follow(hashtag: Hashtag, data: String) {
        return
    }
    
    func unFollow(hashtag: Hashtag, data: String) {
        return
    }

}
