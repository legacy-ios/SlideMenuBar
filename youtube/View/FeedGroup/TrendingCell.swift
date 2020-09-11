//
//  TrendingCell.swift
//  youtube
//
//  Created by jungwooram on 2020-06-11.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    override func fetchVideos() {
        APIService.shard.fetchTrendingFeeds() { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
