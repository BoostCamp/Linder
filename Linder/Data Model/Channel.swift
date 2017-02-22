//
//  Channel.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 25..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

typealias ChannelID = Int64

class Channel {
    var id: ChannelID = .dummy
    var title: String
    var thumbnailURL: URL?
    var image: UIImage?
    var description: String?
    var eventIDs: [EventID] = []
    var hashtags: [Hashtag] = []
    var updatedAt: Date = Date()
    
    var followersCount: Int = 0
    //var followers: [User] = []
    
    // Dummy Creator
    convenience init() {
        self.init(title: "테스트 채널")
        eventIDs = [1]
        followersCount = 238
    }
    
    convenience init(id: ChannelID) {
        self.init(title: "")
        self.id = id
    }
    
    init(id: ChannelID = .dummy, title: String, thumbnailURL: URL? = nil, hashtags: [Hashtag] = [], eventIDs: [EventID] = [], updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.hashtags = hashtags
        self.eventIDs = eventIDs
        self.updatedAt = updatedAt
    }
}

extension ChannelID {
    //static let dummy: ChannelID = 0
}
