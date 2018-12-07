//
//  MyFeedPresenter.swift
//  empathy-ios
//
//  Created by byungtak on 06/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation

protocol MyFeedView {
    func showMyFeeds(myFeeds: [MyFeed])
}

class MyFeedPresenter: BasePresenter {

    private let service: EmpathyService
    
    private var view: MyFeedView?
    
    init(service: EmpathyService) {
        self.service = service
    }
    
    func attachView<T>(view: T) {
        self.view = view as? MyFeedView
    }
    
    func detachView() {
        self.view = nil
    }

    func fetchMyFeeds(userId: Int) {
        self.service.fetchMyFeeds(userId: userId) { [weak self] response in
            
            switch response {
            case .success(let result):
                self?.view?.showMyFeeds(myFeeds: result)
            case .failure(let message):
                print("error \(message)")
            }
            
        }
    }
    
}
