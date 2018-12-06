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
            if let myJourneys = response.result.value as? [MyFeed] {
                completion(myJourneys)
            }
        }
    }
}
