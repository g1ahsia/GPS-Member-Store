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
    var cachedImages = [Int: UIImage]()
    
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
        NetworkManager.fetchRequests() { (requests) in
            self.requests = requests
            DispatchQueue.main.async {
                self.requestTableView.reloadData()
            }
            if (requests.count > 0) {
                for index in 0...requests.count - 1 {
                    let attachments = self.requests[index].attachments
                    let requestId = self.requests[index].id
                    DispatchQueue.main.async {
                        self.loadImages(attachments, indexPath: NSIndexPath(row: index, section: 0) as IndexPath, messageId: requestId)
                    }
                }
            }
        }
        let param = ["requests" : 0]
        NetworkManager.updateStoreBadges(parameters: param) { (result) in
        }
        NotificationCenter.default.post(name: Notification.Name("clearRequestBadge"), object: nil, userInfo: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "調撥平台"
        requestTableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(requestTableView)

        var image = UIImage(#imageLiteral(resourceName: " ic_fill_add"))
        image = image.withRenderingMode(.alwaysOriginal)
//        let add = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(self.addButtonTapped)) //
        let add = UIBarButtonItem(title: "新增", style: .done, target: self, action: #selector(self.addButtonTapped))
        self.navigationItem.rightBarButtonItem  = add

        setupLayout()
        
//        BADGE_REQUEST = 0
//        UserDefaults.standard.set(BADGE_REQUEST, forKey: "BADGE_REQUEST")
//        NotificationCenter.default.post(name: Notification.Name("getBadges"), object: nil, userInfo: nil)

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
        if (self.cachedImages[requests[indexPath.row].id] != nil) {
            cell.mainImage = self.cachedImages[requests[indexPath.row].id]!
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let requestDetailVC = RequestDetailViewController()
        requestDetailVC.title = REQUEST_SUBJECTS[requests[indexPath.row].typeId - 1]
        requestDetailVC.request = self.requests[indexPath.row]
        requestDetailVC.threadId = self.requests[indexPath.row].id
        requestDetailVC.reloadData()
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(requestDetailVC, animated: true)
        }
    }
    
    func loadImages(_ urlStrings: [String], indexPath: IndexPath, messageId : Int) {
        print("loading images for cell " + String(indexPath.row))

        if urlStrings.count > 0 {
            let url = URL(string: urlStrings[0])!

            let downloadTask:URLSessionDownloadTask =
                URLSession.shared.downloadTask(with: url, completionHandler: { [self]
                (location: URL?, response: URLResponse?, error: Error?) -> Void in
                    
                print("got image for cell " + String(indexPath.row))

                if let location = location {
                    if let data:Data = try? Data(contentsOf: location) {
                        if let image:UIImage = UIImage(data: data) {
                            cachedImages[messageId] = image
                        }
                        else {
                            print("CANNOT DOWNLOAD IMAGE \(location)")
                            cachedImages[messageId] = #imageLiteral(resourceName: "img_holder")

                        }
                        DispatchQueue.main.async(execute: { () -> Void in
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            print("reload cell ", String(indexPath.row))
                            
                            UIView.performWithoutAnimation({
                                let loc = self.requestTableView.contentOffset
                                self.requestTableView.beginUpdates()
                                self.requestTableView.reloadRows(at: [indexPath], with: .none)
                                self.requestTableView.contentOffset = loc
                                self.requestTableView.endUpdates()
                            })
                        })

                    }
                }
            })
            downloadTask.resume()
        }
    }
    
}



