//
//  OtherPeoplJourney.swift
//  empathy-ios
//
//  Created by Suji Kim on 01/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation

struct OtherPeopleJourney: Codable {
    let journeyId: Int?
    let ownerProfileUrl: String?
    let ownerName: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case journeyId = "journeyId"
        case ownerProfileUrl = "ownerProfileUrl"
        case ownerName = "ownerName"
        case imageUrl = "imageUrl"
    }
}
