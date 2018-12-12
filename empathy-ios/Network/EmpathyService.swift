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
    
    static let empathyInstance = EmpathyService()
    
    func fetchMyFeeds(userId: Int, completion: @escaping (RequestResult<[MyFeed]>) -> Void) {
        let url = baseUrl + "/journey/myjourney/\(userId)"
        
        Alamofire.request(url).responseJSON { response in
            
            if let myFeeds = response.result.value as? [MyFeed] {
                completion(RequestResult.success(myFeeds))
            }
        }
    }
    
    func fetchDetailFeed(feedId: Int, completion: @escaping ((RequestResult<FeedDetail>) -> Void)) {
        let url = baseUrl + "/journey/\(feedId)"
        
        Alamofire.request(url).responseJSON { response in
            
            if let feed = response.result.value {
                let feed = feed as? [String: Any]
                
                let contents = feed?["contents"] as? String
                let creationTime = feed?["creationTime"] as? String
                let imageUrl = feed?["imageUrl"] as? String
                let journeyId = feed?["journeyId"] as? Int
                let location = feed?["location"] as? String
                let ownerProfileUrl = feed?["ownerProfileUrl"] as? String
                let title = feed?["title"] as? String
                
                let feedDetail = FeedDetail(contents: contents!, creationTime: creationTime!, imageUrl: imageUrl!, journeyId: journeyId!, location: location!, ownerProfileUrl: ownerProfileUrl!, title: title!)
                
                completion(RequestResult.success(feedDetail))
            } else {
                completion(RequestResult.failure(message: "서버에 문제가 생겼습니다. 다시 한번 시도해주세요."))
            }
        }
    }
    
    func postLoginFacebook(_ name: String, _ pictureURL :String, _ appUserId :String, completion: @escaping (RequestResult<UserInfo>) -> Void) {
        let url = baseUrl + "/user/"
        
        Alamofire.request(url,
                          method: .post,
                          parameters: ["name": name, "loginApi": "facebook" , "profileUrl": pictureURL, "appUserId":  appUserId],
                          encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                            
                            if let json = (response.result.value as? Int){
                                let user = UserInfo.init(userId: json, name: name, pictureURL: pictureURL)
                                
                                UserInfoManager.shared.userInfo = user
                                
                                completion(RequestResult.success(user))
                            } else {
                                completion(RequestResult.failure(message: ""))
                            }
        }
    }
    
    func fetchMainFeed(location: String, userId: String, completion: @escaping (RequestResult<MainFeed>) -> Void) {
        let url = baseUrl + "/journey/main/\(location)/\(userId)"
        
        Alamofire.request(url).responseJSON { response in
            
            if let mainFeed = response.result.value as? MainFeed {
                
                print("mainFeed \(mainFeed.mainText)")
//                let decoder = JSONDecoder()
//
//                do {
//                    let mainFeed = try decoder.decode(MainFeed.self, from: data)
////                    self.mainFeedInfo  = mainFeedInfo
////                        print("⭐️mainFeedInfo:", mainFeedInfo)
//                    //self.update(detailInfo: detailInfo)
//                } catch let DecodingError.dataCorrupted(context) {
//                    print(context)
//                } catch let DecodingError.keyNotFound(key, context) {
//                    print("Key '\(key)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch let DecodingError.valueNotFound(value, context) {
//                    print("Value '\(value)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch let DecodingError.typeMismatch(type, context)  {
//                    print("Type '\(type)' mismatch:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch {
//                    print("error: ", error)
//                }
//                DispatchQueue.main.async {
//                    if let info =  {
//                        self.update(mainfeedInfo: info)
//                    }
//                }
            }
        }
    }
}
