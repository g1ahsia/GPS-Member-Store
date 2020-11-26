//
//  RequestViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/24.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class RequestViewController: UIViewController {
    
    var requests = [Request]()
    
    lazy var requestTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 102
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RequestCell.self, forCellReuseIdentifier: "request")
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.requestTableView.indexPathForSelectedRow != nil) {
            self.requestTableView.deselectRow(at: self.requestTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "調撥平台"
        requestTableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(requestTableView)

        var image = UIImage(#imageLiteral(resourceName: " ic_fill_add"))
        image = image.withRenderingMode(.alwaysOriginal)
        let add = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(self.addButtonTapped)) //
        self.navigationItem.rightBarButtonItem  = add

        
        NetworkManager.fetchRequests() { (requests) in
            self.requests = requests
            DispatchQueue.main.async {
                self.requestTableView.reloadData()
            }
        }

        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name:Notification.Name("CreatedRequest"), object: nil)

    }
        
    @objc private func addButtonTapped() {
        let requestComposeVC = RequestComposeViewController()
        if #available(iOS 13.0, *) {
            requestComposeVC.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(requestComposeVC, animated: true) {
        }
    }
    
    private func setupLayout() {
        requestTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        requestTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        requestTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        requestTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @objc private func reloadData () {
        NetworkManager.fetchRequests() { (requests) in
            self.requests = requests
            DispatchQueue.main.async {
                self.requestTableView.reloadData()
            }
        }
    }
}

extension RequestViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == requestTableView) {
            return requests.count
        }
        else {
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request", for: indexPath) as! RequestCell
        cell.storeName = requests[indexPath.row].storeName
        cell.typeId = requests[indexPath.row].typeId
        cell.desc = requests[indexPath.row].description
        cell.updatedDate = requests[indexPath.row].updatedDate
        cell.attachments = requests[indexPath.row].attachments
        cell.layoutSubviews()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let requestDetailVC = RequestDetailViewController()
        requestDetailVC.title = REQUEST_SUBJECTS[requests[indexPath.row].typeId - 1]
        
        NetworkManager.fetchRequestMessages(id: requests[indexPath.row].id) { (messages) in
            requestDetailVC.request = self.requests[indexPath.row]
            requestDetailVC.messages = messages
            requestDetailVC.threadId = self.requests[indexPath.row].id
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(requestDetailVC, animated: true)
            }
        }
    }
    
}



