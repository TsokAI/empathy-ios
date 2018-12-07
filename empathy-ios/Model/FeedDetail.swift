//
//  FeedDetail.swift
//  empathy-ios
//
//  Created by byungtak on 29/11/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation

//{
//    "contents": "string",
//    "creationTime": "string",
//    "imageUrl": "string",
//    "journeyId": 0,
//    "location": "string",
//    "ownerProfileUrl": "string",
//    "title": "string"
//}
struct FeedDetail: Codable {
    let contents: String
    let creationTime: String
    let imageUrl: String
    let journeyId: Int
    let location: String
    let ownerProfileUrl: String
    let title: String
    
    init(contents: String,
         creationTime: String,
         imageUrl: String,
         journeyId: Int,
         location: String,
         ownerProfileUrl: String,
         title: String) {
        
        self.contents = contents
        self.creationTime = creationTime
        self.imageUrl = imageUrl
        self.journeyId = journeyId
        self.location = location
        self.ownerProfileUrl = ownerProfileUrl
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case contents, creationTime, imageUrl, journeyId, location, ownerProfileUrl, title
    }
}
