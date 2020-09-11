//
//  APIService.swift
//  youtube
//
//  Created by jungwooram on 2020-06-11.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import Foundation

class APIService: NSObject {
    
    static let shard = APIService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping([Video]) -> Void) {
        fetchFeed(withUrl: "\(baseUrl)/home.json", completion: completion)
    }
    
    func fetchTrendingFeeds(completion: @escaping([Video]) -> Void) {
        fetchFeed(withUrl: "\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeeds(completion: @escaping([Video]) -> Void) {
        fetchFeed(withUrl: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    func fetchFeed(withUrl url: String, completion: @escaping([Video]) -> Void) {
        
        if let url = URL(string: url) {
            
            let request = URLRequest(url: url)
            let urlSession = URLSession(configuration: .default)
            let tast = urlSession.dataTask(with: request) { (data, res, err) in
                
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                do {
                    if let unwrappedData = data,
                        
                        let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: AnyObject]] {
                        
                        var videos = [Video]()
                        for dic in jsonDictionaries {
                            let video = Video(dictionary: dic)
                            videos.append(video)
                        }
                        
                        DispatchQueue.main.async {
                            completion(videos)
                        }
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            }
            tast.resume()
        }
    }
}
