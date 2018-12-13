//
//  MainFeedViewController.swift
//  empathy-ios
//
//  Created by Suji Kim on 25/11/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import UIKit
import Alamofire
import Toaster

class MainFeedViewController: UIViewController {

    @IBOutlet weak var peopleJourneyCollectionView: UICollectionView!
    @IBOutlet weak var smileLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var placeHolderView: UIView!
    @IBOutlet weak var myJourneyView: UIView!
    @IBOutlet weak var myJourneyImageView: UIImageView!
    @IBOutlet weak var myJourneyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    private var mainFeed: MainFeed?
    private var locationEnum: LocationEnum?
    
    private let presenter = MainFeedPresenter(service: EmpathyService.empathyInstance)
    
    var userInfo:UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attachView(view: self)
        
        initializeView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        LocationManager.shared.requestLocation { (locationCoordinate2D) in
            if let locationCoordinate2D = locationCoordinate2D {
                self.locationEnum = LocationManager.shared.getNearestLocationEnum(location: locationCoordinate2D)
                self.locationLabel.text = "Seoul"
            }
            
            if let id = self.userInfo?.userId {
                self.presenter.fetchMainFeed(location: "Seourl", userId: String(id))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMyFeed",
            let destination = segue.destination as? MyFeedViewController {
            
            destination.userInfo = self.userInfo
        }
        else if segue.identifier == "toCamera",
            let destination = segue.destination as? CameraViewController {
            
            destination.userInfo = self.userInfo
        }
    }
    
    @IBAction func tapMyFeed(_ sender: UIButton) {
        if let viewController = UIStoryboard.init(name: "MyFeed", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyFeedViewController") as? MyFeedViewController {
            
            viewController.userInfo = userInfo
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapToursiteButton(_ sender: Any) {
        let randomNumber: Int? = Int.random(in: 0 ... 10)
        
        guard let random = randomNumber else {
            return
        }
        
        if random % 2 == 0 {
            if let viewController = UIStoryboard.init(name: "TouristSite", bundle: Bundle.main).instantiateViewController(withIdentifier: "TouristSiteViewController") as? TouristSiteViewController {
                self.present(viewController, animated: true, completion: nil)
            }
            
        } else {
            if let viewController = UIStoryboard.init(name: "Affiliate", bundle: Bundle.main).instantiateViewController(withIdentifier: "AffiliateViewController") as? AffiliateViewController {
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    private func initializeView() {
        self.smileLabel.transform = CGAffineTransform(rotationAngle:  CGFloat.pi / 2)
    }
    
    deinit {
        self.presenter.detachView()
    }

}

extension MainFeedViewController: MainFeedView {
    func showMyFeedPlaceholder() {
        self.placeHolderView.isHidden = false
        self.myJourneyView.isHidden = true
    }
    
    func showMainFeed(mainFeed: MainFeed) {
        self.cityLabel.text = mainFeed.enumStr
        self.weekdayLabel.text = mainFeed.weekday
        
        self.mainFeed = mainFeed
        self.peopleJourneyCollectionView.reloadData()
    }
    
    func showMyFeedInformation(mainFeed: MainFeed) {
        self.placeHolderView.isHidden = true
        self.myJourneyView.isHidden = false
        self.myJourneyLabel.text = mainFeed.mainText
        
        if  let journeyURL = URL(string: mainFeed.imageURL) {
            self.myJourneyImageView.kf.setImage(with: journeyURL)
        }
    }
    
    func showFailure(message: String) {
        Toast.init(text: message).show()
    }
}

extension MainFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let info = mainFeed?.otherPeopleList[indexPath.row],
            let viewController = UIStoryboard
                .init(name: "FeedDetail", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "FeedDetailViewController") as? FeedDetailViewController {

            viewController.feedId = info.journeyId
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfItem = mainFeed?.otherPeopleList.count {
            if numberOfItem < 18 {
                return numberOfItem
            }
            else {
                return 18
            }
        }
        else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = peopleJourneyCollectionView.dequeueReusableCell(withReuseIdentifier: "peopleJourney", for: indexPath) as? MainFeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let info = mainFeed?.otherPeopleList[indexPath.row] {
            if let ownerImageURLString = info.ownerProfileUrl as? String, let journeyImageURLString = info.imageUrl as? String {
                cell.config(info.ownerName ?? "-", ownerImageURLString , journeyImageURL: journeyImageURLString ?? "-")
            }
        }
        return cell
    }
    
}

extension MainFeedViewController: UICollectionViewDelegate {
    
}
