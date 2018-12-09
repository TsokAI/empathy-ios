//
//  LoginPresenter.swift
//  empathy-ios
//
//  Created by Tak on 09/12/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore

protocol LoginView {
    func navigateToMainFeedView(user: UserInfo)
}

class LoginPresenter: BasePresenter {
    
    private var view: LoginView?
    
    private let service: EmpathyService
    
    init(service: EmpathyService) {
        self.service = service
    }
    
    func attachView<T>(view: T) {
        self.view = view as? LoginView
    }
    
    func detachView() {
        self.view = nil
    }
    
    func fetchUserInformation(accessToken: AccessToken) {
        self.fetchUserInformation { userInfo, error in
            if  let userInfo = userInfo,
                let name = (userInfo["name"] as? String),
                let pictureURL = (userInfo["picture"] as? [String:Any])?["data"] as? [String:Any],
                let appUserId = accessToken.userId {
                
                if let url = (pictureURL["url"] as? String) {
                    self.service.postLoginFacebook(name, url, appUserId) { [weak self] response in
                        
                        switch response {
                        case .success(let user):
                            self?.view?.navigateToMainFeedView(user: user)
                        case .failure(let message):
                            print("login error \(message)")
                        }
                    }
                }
            }
        }
    }
    
    func fetchUserInformation( completion: @escaping (_ : [String:Any]?, _ : Error?) -> Void) {
        let request = GraphRequest(graphPath: "me", parameters: ["fields" :"id,name, email, picture"])
        request.start { response, result in
            
            switch result {
            case .failed(let error):
                completion(nil, error)
            case .success(let graphResponse):
                completion(graphResponse.dictionaryValue, nil)
            }
        }
    }
}
