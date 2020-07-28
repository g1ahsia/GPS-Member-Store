//
//  MessageViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/23.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

struct MessageData {
    let subject : String?
    let message : String?
}

class MessageViewController: UIViewController {
    
    var messageData = [MessageData]()
        
    lazy var messageTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 102
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "message")
        return tableView

    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.messageTableView.indexPathForSelectedRow != nil) {
            self.messageTableView.deselectRow(at: self.messageTableView.indexPathForSelectedRow!, animated: true)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "會員訊息"
        view.addSubview(messageTableView)
        
        
//        var image = UIImage(#imageLiteral(resourceName: "ic_fill_add"))
//        image = image.withRenderingMode(.alwaysOriginal)
//        let add = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(self.addButtonTapped)) //
//        self.navigationItem.rightBarButtonItem  = add

        messageData = [MessageData.init(subject: "hot", message: "desc"),
                MessageData.init(subject: "hot", message: "desc"),
                MessageData.init(subject: "hot", message: "desc"),
                MessageData.init(subject: "hot", message: "desc"),
                MessageData.init(subject: "hot", message: "desc"),
                MessageData.init(subject: "hot", message: "desc"),
                MessageData.init(subject: "hot", message: "desc"),
                MessageData.init(subject: "hot", message: "desc"),
                MessageData.init(subject: "hot", message: "desc")]

        setupLayout()

    }
    
    @objc private func addButtonTapped() {
        let messageComposeVC = MessageComposeViewController()
        messageComposeVC.messageType = MessageType.New
        messageComposeVC.isModalInPresentation = true
        self.present(messageComposeVC, animated: true) {
        }
    }
    
    private func setupLayout() {
        messageTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messageTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        messageTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messageTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == messageTableView) {
            return messageData.count
        }
        else {
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageCell
        cell.subject = "預約領取處方"
        cell.message = "最近體重的事情一直煩惱著我，想請教如何減重？我真的很需要建議，謝謝！"
        cell.date = "2020/04/21 15:35"
        cell.layoutSubviews()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageDetailVC = MessageDetailViewController()
        messageDetailVC.title = "預約領取處方"
        self.navigationController?.pushViewController(messageDetailVC, animated: true)
    }
    
}



