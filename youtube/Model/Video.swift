//
//  Video.swift
//  youtube
//
//  Created by jungwooram on 2020-06-09.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit

class Video: NSObject {
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: NSNumber?
    var uploadDate: NSDate?
    var duration: NSNumber?
    var channel: Channel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "channel" {
            //self.channel = Channel()
            //self.channel?.setValuesForKeys(value as! [String : AnyObject])
        } else {
            //super.setValue(value, forKey: key)
        }
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        //setValuesForKeys(dictionary)
        self.thumbnail_image_name = dictionary["thumbnail_image_name"] as? String
        self.title = dictionary["title"] as? String
        self.number_of_views = dictionary["number_of_views"] as? NSNumber
        self.duration = dictionary["duration"] as? NSNumber
        let channel = dictionary["channel"] as? [String: AnyObject]
        self.channel = Channel()
        self.channel?.name = channel?["name"] as? String
        self.channel?.profile_image_name = channel?["profile_image_name"] as? String

    }
}

class Channel: NSObject {
    var name: String?
    var profile_image_name: String?
}
