//
//  EmpathyService.swift
//  empathy-ios
//
//  Created by byungtak on 06/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation
import Alamofire

let baseUrl = "http://ec2-13-209-245-253.ap-northeast-2.compute.amazonaws.com:8080"

class EmpathyService {
    
    func fetchMyFeeds(userId: Int, completion: @escaping ([MyFeed]) -> ()) {
        let url = baseUrl + "/journey/myjourney/\(userId)"
        
        Alamofire.request(url).responseJSON { response in
            if let myFeeds = response.result.value as? [MyFeed] {
                completion(myFeeds)
            }
        }
    }
    
    func fetchDetailFeed(feedId: Int) {
        let url = baseUrl + "/journey/\(feedId)"
        
        Alamofire.request(url).responseJSON { response in
            if let feed = response.result.value {
                let feed = feed as? [String: Any]
                
                let title = feed?["title"] as? String
                let contents = feed?["contents"] as? String
                let location = feed?["location"] as? String
                let time = feed?["creationTime"] as? String
                let imageUrl = feed?["imageUrl"] as? String
                let journeyId = feed?["journeyId"] as? Int
                let ownerProfileUrl = feed?["ownerProfileUrl"] as? String
                
                let feedDetail = FeedDetail()
                
            }
        }
        
//        Alamofire.request(url).responseJSON { (response) in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//
//
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//                self.journeyDetail = json as? [String : Any]
//            }
//
//            if let info = self.journeyDetail {
//                self.update(info)
//            }
//        }
    }
}
