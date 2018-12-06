//
//  MyFeedPresenter.swift
//  empathy-ios
//
//  Created by Tak on 05/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation

protocol MyFeedView {
    func showDeleteFeedAlert(indexPath: IndexPath)
    
}

class MyFeedPresenter {
    
    private let service: EmpathyService
    private var view: MyFeedView?
    
    init() {
        self.service = EmpathyService()
    }
    
    func attachView(view: MyFeedView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func fetchMyFeeds(userId: Int) {
        self.service.fetchMyFeeds(userId: userId)
    }
    
}
