//
//  FeedDetailViewController.swift
//  empathy-ios
//
//  Created by byungtak on 29/11/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import UIKit
import Alamofire
import Toaster

class FeedDetailViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var journeyImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBAction func tapBackAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private let presenter = FeedDetailPresenter(service: EmpathyService())
    
    private var feedDetail: FeedDetail?
    
    var feedId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.attachView(view: self)
        
        if let feedId = self.feedId {
            self.presenter.fetchDetailFeed(feedId: feedId)
        }
        
        initializeView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.presenter.detachView()
    }

    private func initializeView() {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
    }
}

extension FeedDetailViewController: FeedDetailView {
    
    func showFailure(message: String) {
        Toast(text: message, delay: Delay.short, duration: Delay.long).show()
    }
    
    func showFeed(feedDetail: FeedDetail) {
        titleLabel.text = feedDetail.title
        contentsLabel.text = feedDetail.contents
        locationLabel.text = feedDetail.location
        dateLabel.text = feedDetail.creationTime
    
        userImage.kf.setImage(with: URL(string: feedDetail.ownerProfileUrl))
        journeyImageView.kf.setImage(with: URL(string: feedDetail.imageUrl))
    }
}
