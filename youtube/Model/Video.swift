//
//  Video.swift
//  youtube
//
//  Created by jungwooram on 2020-06-09.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit

class Video {
    var thumbNailImage: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    var channel: Channel?
}

class Channel {
    var name: String?
    var profileImage: String?
}
