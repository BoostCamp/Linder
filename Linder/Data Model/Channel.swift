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
    var thumbnail: UIImage?
    var image: UIImage?
    var description: String?
    var eventIDs: [EventID] = []
    var hashtags: [Hashtag] = []
    
    var followersCount: Int = 0
    //var followers: [User] = []
    
    // Dummy Creator
    convenience init() {
        self.init(title: "테스트 채널")
        thumbnail = #imageLiteral(resourceName: "channel")
        eventIDs = [1]
        followersCount = 238
    }
    
    init(title: String) {
        self.title = title
    }
    
    init(title: String, thumbnail: UIImage) {
        self.title = title
        self.thumbnail = thumbnail
    }
    
    init(title: String, thumbnail: UIImage, hashtags: [Hashtag], eventIDs: [EventID]) {
        self.title = title
        self.thumbnail = thumbnail
        self.hashtags = hashtags
        self.eventIDs = eventIDs
    }
}

extension ChannelID {
    //static let dummy: ChannelID = 0
}
