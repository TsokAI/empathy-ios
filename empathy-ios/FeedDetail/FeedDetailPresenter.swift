//
//  FeedDetailPresenter.swift
//  empathy-ios
//
//  Created by Tak on 07/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation

protocol FeedDetailView {
    func showFeed(feedDetail: FeedDetail)
    func showFailure(message: String)
}

class FeedDetailPresenter: BasePresenter {
    
    private let service: EmpathyService
    
    private var view: FeedDetailView?
    
    init(service: EmpathyService) {
        self.service = service
    }
    
    func attachView<T>(view: T) {
        self.view = view as? FeedDetailView
    }
    
    func detachView() {
        self.view = nil
    }
    
    func fetchDetailFeed(feedId: Int) {
        self.service.fetchDetailFeed(feedId: feedId) { [weak self] response in
            
            switch response {
            case .success(let result):
                self?.view?.showFeed(feedDetail: result)
            case .failure(let message):
                self?.view?.showFailure(message: message)
            }   
        }
    }
    
}
