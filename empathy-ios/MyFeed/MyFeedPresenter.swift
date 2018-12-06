//
//  MyFeedPresenter.swift
//  empathy-ios
//
//  Created by byungtak on 06/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation

protocol MyFeedView {
    func showMyFeeds(myJourneys: [MyJourney])
}

class MyFeedPresenter {

    private let service: EmpathyService
    
    private var view: MyFeedView?
    
    init(service: EmpathyService) {
        self.service = service
    }
    
    func attachView(view: MyFeedView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func fetchMyFeeds(userId: Int) {
        self.service.fetchMyFeeds(userId: userId) { [weak self] myJourneys in
            
            self?.view?.showMyFeeds(myJourneys: myJourneys)
        }
    }
    
}
