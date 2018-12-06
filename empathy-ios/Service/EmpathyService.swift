//
//  EmpathyService.swift
//  empathy-ios
//
//  Created by Tak on 05/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation
import Alamofire

class EmpathyService {
    
    
    func fetchMyFeeds(userId: Int) {
        let urlPath = Commons.baseUrl + "/journey/myjourney/\(userId)"

        Alamofire.request(urlPath).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value as? [MyJourney] {
                print("JSON: \(json)") // serialized json response
                // TODO : 초기화 -> cell에 뿌리는 부분!
                
            }
            
            if let data = response.data {
                let decoder = JSONDecoder()
                print("JSON: \(data)")
                do {
                } catch let e {
                    print(e)
                }
            }
            
//            if let info = self.myJourneyLists {
//                self.update(myJourneyList: info)
//            }
//            else {
//                self.update(myJourneyList: [])
//            }
        }
    }
}
