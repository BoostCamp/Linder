//
//  Channel.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Linder. All rights reserved.
//

import UIKit

class Channel {
    var title: String
    var thumbnail: UIImage?
    var image: UIImage?
    var description: String?
    var events: [Event]?
    
    init(title: String) {
        self.title = title
    }
    
    init(title: String, thumbnail: UIImage) {
        self.title = title
        self.thumbnail = thumbnail
    }
}
