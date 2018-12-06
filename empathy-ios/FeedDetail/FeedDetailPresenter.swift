//
//  FeedDetailPresenter.swift
//  empathy-ios
//
//  Created by Tak on 07/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation

protocol FeedDetailView {
    
}

class FeedDetailPresenter: BasePresenter {
    
    let service: EmpathyService?
    
    init(service: EmpathyService) {
        self.service = service
    }
    
    
    
}
