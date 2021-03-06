//
//  MainFeedPresenter.swift
//  empathy-ios
//
//  Created by Tak on 13/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation


protocol MainFeedView {
    func showFailure(message: String)
    func showMyFeedPlaceholder()
    func showMyFeedInformation(mainFeed: MainFeed)
    func showMainFeed(mainFeed: MainFeed)
}

class MainFeedPresenter: BasePresenter {
    
    private let service: EmpathyService

    private var view: MainFeedView?
    
    init(service: EmpathyService) {
        self.service = service
    }
    
    func attachView<T>(view: T) {
        self.view = view as? MainFeedView
    }
    
    func detachView() {
        self.view = nil
    }
    
    func fetchMainFeed(location: String, userId: String) {
        self.service.fetchMainFeed(locationEnum: location, userId: userId) { [weak self] response in
            
            switch response {
            case .success(let result):
                if result.isFirst == "true" {
                    self?.view?.showMyFeedPlaceholder()
                } else {
                    self?.view?.showMyFeedInformation(mainFeed: result)
                }
                
                self?.view?.showMainFeed(mainFeed: result)
            case .failure(let message):
                self?.view?.showFailure(message: message)
            }
        }
    }
}
