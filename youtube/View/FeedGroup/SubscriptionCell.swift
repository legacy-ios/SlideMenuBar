//
//  SubscriptionCell.swift
//  youtube
//
//  Created by jungwooram on 2020-06-11.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    override func fetchVideos() {
        APIService.shard.fetchSubscriptionFeeds() { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
