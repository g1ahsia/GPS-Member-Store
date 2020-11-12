//
//  RequestDetailViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/29.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit


class RequestDetailViewController: UIViewController {
    var messages = [RequestMessage]()
    var tempImage : UIImage?
    var threadId : Int = 0
    var cachedImages = [UIImage]()
    
//    let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 22, width: UIScreen.main.bounds.width, height: 44))
    
    lazy var messageDetailTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 102
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "message")
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        view.addSubview(messageDetailTableView)
        setupLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name:Notification.Name("AddedRequestMessage"), object: nil)
    }
    
    @objc private func addButtonTapped() { }
    
    private func setupLayout() {
        messageDetailTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        messageDetailTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messageDetailTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messageDetailTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @objc private func customerButtonTapped() {
        let consumerDetailVC = ConsumerDetailViewController()
        consumerDetailVC.id = 1
        self.navigationController?.pushViewController(consumerDetailVC, animated: true)
    }
    
    func loadImage(_ url: URL, indexPath: IndexPath) {
        let downloadTask:URLSessionDownloadTask =
            URLSession.shared.downloadTask(with: url, completionHandler: {
            (location: URL?, response: URLResponse?, error: Error?) -> Void in
            if let location = location {
                if let data:Data = try? Data(contentsOf: location) {
                    if let image:UIImage = UIImage(data: data) {
                        self.cachedImages[indexPath.row] = image // Save into the cache
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.messageDetailTableView.beginUpdates()
                            self.messageDetailTableView.reloadRows(
                                at: [indexPath],
                                with: .fade)
                            self.messageDetailTableView.endUpdates()
                        })
                    }
                }
            }
        })
        downloadTask.resume()
    }

}

extension RequestDetailViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == messageDetailTableView) {
            return messages.count
        }
        else {
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageCell
        cell.viewController = self
//        if (indexPath.row == 0) {
            cell.sender = messages[indexPath.row].storeName + messages[indexPath.row].storeUserName
            cell.message = messages[indexPath.row].message
            cell.date = messages[indexPath.row].date
//            cell.attachments = messages[indexPath.row].attachments
//        cell.attachedImages = self.cachedImages
            cell.layoutSubviews()
//        }
//        else {
//            cell.sender = messages[indexPath.row].sender
//            cell.message = messages[indexPath.row].message
//            cell.date = messages[indexPath.row].date
//            cell.layoutSubviews()
//        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = SNOW
        if tableView == messageDetailTableView {
            footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
            let border = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
            border.backgroundColor = DEFAULT_SEPARATOR
            footerView.addSubview(border)
            let button =  UIButton()
            button.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.width - 20*2, height: 44)
            button.translatesAutoresizingMaskIntoConstraints = true
            button.setTitle("回覆", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
            button.backgroundColor = ATLANTIS_GREEN
            button.layer.cornerRadius = 10;
            button.addTarget(self, action: #selector(replyButtonTapped), for: .touchUpInside)
            footerView.addSubview(button)
            return footerView

        }
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)

        return footerView

        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == messageDetailTableView {
            return 64
        }
        else {
            return 0
        }
    }

    @objc private func replyButtonTapped(sender: UIButton!) {
        let messageComposeVC = MessageComposeViewController()
        messageComposeVC.messageType = MessageType.ReplyRequest
        messageComposeVC.threadId = threadId
        messageComposeVC.role = Role.MemberStore
        if #available(iOS 13.0, *) {
            messageComposeVC.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(messageComposeVC, animated: true) {
        }
    }
    
    @objc private func reloadData () {
//        if (role == Role.Consumer) {
            NetworkManager.fetchRequestMessages(id: threadId) { (messages) in
                self.messages = messages
                DispatchQueue.main.async {
                    self.messageDetailTableView.reloadData()
                }
            }
//        }
//        else {
//            NetworkManager.fetchStoreMessages(id: threadId) { (messages) in
//                self.messages = messages
//                DispatchQueue.main.async {
//                    self.messageDetailTableView.reloadData()
//                }
//            }
//        }
    }

}
