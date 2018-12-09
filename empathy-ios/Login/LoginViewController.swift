//
//  LoginViewController.swift
//  empathy-ios
//
//  Created by Suji Kim on 09/11/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Alamofire
import Toaster

class LoginViewController: UIViewController {

    @IBOutlet weak var facebookLoginButton: RoundedButton!
    
    private let presenter = LoginPresenter(service: EmpathyService.empathyInstance)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.attachView(view: self)
        
        self.facebookLoginButton.addTarget(self, action: #selector(facebookLoginButtonClicked), for: .touchUpInside)
    }
    
    @objc func facebookLoginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                Toast(text: "정보를 받아올 수 없습니다.").show()
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                print(accessToken)
                self.presenter.fetchUserInformation(accessToken: accessToken)
            }
        }
    }

    func getUserInformation( completion: @escaping (_ : [String:Any]?, _ : Error?) -> Void) {
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
    
    deinit {
        self.presenter.detachView()
    }
}

extension LoginViewController: LoginView {
    func navigateToMainFeedView(user: UserInfo) {
        if let viewController = UIStoryboard.init(
            name: "MainFeed",
            bundle: Bundle.main
            ).instantiateViewController(withIdentifier: "MainFeedViewController") as? MainFeedViewController {
            
            viewController.userInfo = user
            
            self.navigationController?.pushViewController(viewController, animated: true)
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

