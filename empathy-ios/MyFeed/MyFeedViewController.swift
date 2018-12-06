//
//  MyFeedViewController.swift
//  empathy-ios
//
//  Created by byungtak on 23/11/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import Kingfisher
import Alamofire
import UIKit

class MyFeedViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    private let cellIdentifier = "my_feed_cell"
    private let presenter: MyFeedPresenter = MyFeedPresenter(service: EmpathyService())
    
    private var myFeeds: [MyFeed] = []
    private var imagePicker = UIImagePickerController()
    
    var userInfo:UserInfo?
    var myJourneys:[MyJourney] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        presenter.attachView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let info = userInfo {
            presenter.fetchMyFeeds(userId: info.userId)
        }
    }
    
    private func showDeleteMyFeedAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "여정 삭제하기", message: "작성 하신 여정을 삭제하시겠어요?", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { (action: UIAlertAction) in
            self.myFeeds.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapWriteFeed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
}

extension MyFeedViewController: MyFeedView {
    func showMyFeeds(myJourneys: [MyJourney]) {
        self.myJourneys.removeAll()
        self.myJourneys = myJourneys
        
        self.tableView.reloadData()
    }
    
}

extension MyFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MyFeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MyFeedTableViewCell else {
            return UITableViewCell()
        }
        
        let myFeed = myFeeds[indexPath.row]
    
        cell.roundView.layer.cornerRadius = cell.roundView.frame.size.width / 2
        cell.roundView.clipsToBounds = true
        cell.dateMonth.text = "11.03"
        cell.dateYear.text = "2017"
        cell.title.text = myFeed.title
        cell.feedImage.kf.setImage(with: URL(string: ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            showDeleteMyFeedAlert(indexPath: indexPath)
        }
    }
    
}

extension MyFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
        })

        deleteAction.backgroundColor = UIColor(red: 42/255.0, green: 44/255.0, blue: 52/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "iconRemove")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MyFeedViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let viewController = UIStoryboard.init(name: "WriteFeed", bundle: nil).instantiateViewController(withIdentifier: "WriteFeedViewController") as? WriteFeedViewController {
            if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                viewController.image = img
                viewController.userInfo = userInfo
            }
            self.dismiss(animated: true) {
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
}

