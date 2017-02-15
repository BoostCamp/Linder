//
//  Channel.swift
//  Linder
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
    var events: [Event] = []
    var hashtags: [Hashtag] = []
    
    var followersCount: Int = 0
    //var followers: [User] = []
    
    // Dummy Creator
    convenience init() {
        self.init(title: "테스트 채널")
        thumbnail = #imageLiteral(resourceName: "channel")
        events = Array(repeating: Event(), count: 5)
        followersCount = 238
    }
    
    init(title: String) {
        self.title = title
    }
    
    init(title: String, thumbnail: UIImage) {
        self.title = title
        self.thumbnail = thumbnail
    }
    
    init(title: String, thumbnail: UIImage, hashtags: [Hashtag], events: [Event]) {
        self.title = title
        self.thumbnail = thumbnail
        self.hashtags = hashtags
        self.events = events
    }
}

extension ChannelID {
    //static let dummy: ChannelID = 0
}
