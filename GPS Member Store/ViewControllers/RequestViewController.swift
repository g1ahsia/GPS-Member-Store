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

//        requests = [
//            Request.init(id: 1, type: 0, sender: "松仁藥局", name: "產品名稱", price: 120, quantity: 300, message: "歐樂B兒童防蛀牙膏Mickey 40g", updatedDate: "2020/04/25 15:35"),
//            Request.init(id: 2, type: 0, sender: "松仁藥局", name: "產品名稱", price: 120, quantity: 300, message: "晶亮葉黃膠囊含葉黃素加玻尿酸", updatedDate: "2020/04/23 15:35"),
//            Request.init(id: 3, type: 1, sender: "松仁藥局", name: "產品名稱", price: 120, quantity: 300, message: "空氣抑菌筆", updatedDate: "2020/04/20 15:35")
//        ]
        
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
        cell.layoutSubviews()
        cell.mainImage = #imageLiteral(resourceName: "img_holder")
        if (indexPath.row == 0) {
            cell.mainImage = #imageLiteral(resourceName: "product-img")
        }
        else if (indexPath.row == 1) {
            cell.mainImage = #imageLiteral(resourceName: "001246")
        }
        else {
            cell.mainImage = #imageLiteral(resourceName: "product-img-122")
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let requestDetailVC = RequestDetailViewController()
        requestDetailVC.title = REQUEST_SUBJECTS[requests[indexPath.row].typeId - 1]
//        if (indexPath.row == 0) {
//            messageDetailVC.messages = [
////                Message.init(id: 1, sender: "松仁藥局", message: requests[indexPath.row].message + "\n商品價錢：60元\n商品數量：300\n商品有限，把握機會。", date: "2020/04/20", attachments: ["file"]),
////                Message.init(id: 1, sender: "翰林藥局", message: "我想要訂購30隻", date: "2020/04/21", attachments: [])
//            ]
//            messageDetailVC.tempImage = #imageLiteral(resourceName: "product-img")
//        }
//        else if (indexPath.row == 1) {
//            messageDetailVC.messages = [
////                Message.init(id: 1, sender: "松仁藥局", message: requests[indexPath.row].message + "\n商品價錢：120元\n商品數量：3000\n商品有限，把握機會。", date: "2020/04/20", attachments: ["file"]),
////                Message.init(id: 1, sender: "翰林藥局", message: "我想要訂購100個，謝謝。", date: "2020/04/21", attachments: [])
//            ]
//            messageDetailVC.tempImage = #imageLiteral(resourceName: "001246")
//
//        }
//        else {
//            messageDetailVC.messages = [
////                Message.init·(id: 1, sender: "翰林藥局", message: "我這邊有貨，請跟我聯絡。", date: "2020/04/21", attachments: [])
//            ]
//            messageDetailVC.tempImage = #imageLiteral(resourceName: "product-img-122")
//        }
        
        NetworkManager.fetchRequestMessages(id: requests[indexPath.row].id) { (messages) in
            requestDetailVC.messages = messages
            requestDetailVC.threadId = self.requests[indexPath.row].id
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(requestDetailVC, animated: true)
            }
        }

//        self.navigationController?.pushViewController(requestDetailVC, animated: true)
    }
    
}



