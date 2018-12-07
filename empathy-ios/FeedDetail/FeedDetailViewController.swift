//
//  FeedDetailViewController.swift
//  empathy-ios
//
//  Created by byungtak on 29/11/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import UIKit
import Alamofire

class FeedDetailViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var journeyImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    private let presenter = FeedDetailPresenter(service: EmpathyService())
    
    private var feedDetail: FeedDetail?
    
    var feedId: Int?
    var journeyDetail:[String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.attachView(view: self)
        
        if let feedId = feedId {
            self.presenter.fetchDetailFeed(feedId: feedId)
        }
        
        initializeView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.presenter.detachView()
    }
    
    @IBAction func tapBackAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func update(_ journeydetail:[String:Any]) {
        if let title = journeyDetail?["title"] as? String, let contents = journeyDetail?["contents"] as? String, let location = journeyDetail?["location"] as? String, let time = journeydetail["creationTime"] as? String {
            titleLabel.text = title
            contentsLabel.text = contents
            locationLabel.text = location
            dateLabel.text = time
        }
        
        if let imageString =  journeyDetail?["ownerProfileUrl"] as? String ,let imageURL = URL(string:imageString), let ownerImageString = journeyDetail?["imageUrl"] as? String, let journeyURL = URL(string: ownerImageString) {
            userImage.kf.setImage(with: imageURL)
            journeyImageView.kf.setImage(with: journeyURL)
        }
    }
    
    private func initializeView() {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
    }
}

extension FeedDetailViewController: FeedDetailView {
    
}

// request
extension FeedDetailViewController {
    func requestDetailInfo(_ journeyId:Int){
        let urlPath = Commons.baseUrl + "/journey/\(journeyId)"
        
        Alamofire.request(urlPath).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                self.journeyDetail = json as? [String : Any]
            }
            
            if let info = self.journeyDetail {
                self.update(info)
            }
        }
    }
}
