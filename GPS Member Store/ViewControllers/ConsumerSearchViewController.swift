//
//  ConsumerSearchViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/24.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class ConsumerSearchViewController: UIViewController {
    var consumers = [Consumer]()

    lazy var consumerTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConsumerCell.self, forCellReuseIdentifier: "consumer")
        tableView.backgroundColor = .blue
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.consumerTableView.indexPathForSelectedRow != nil) {
            self.consumerTableView.deselectRow(at: self.consumerTableView.indexPathForSelectedRow!, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        title = "客戶搜尋"
        view.addSubview(consumerTableView)
        
        consumers = [Consumer.init(id: 1, email: "abc@gmail.com", name: "王大寶", dateOfBirth: "2001/20/34", mobilePhone: "0912345678", address: "12342 road", gender: 1, storeId: 1, consumerNumber: "23234", serialNumber: "A121919743"),
                    Consumer.init(id: 1, email: "abc@gmail.com", name: "王大寶", dateOfBirth: "2001/20/34", mobilePhone: "0912345678", address: "12342 road", gender: 1, storeId: 1, consumerNumber: "23234", serialNumber: "A121919743"),
                    Consumer.init(id: 1, email: "abc@gmail.com", name: "王大寶", dateOfBirth: "2001/20/34", mobilePhone: "0912345678", address: "12342 road", gender: 1, storeId: 1, consumerNumber: "23234", serialNumber: "A121919743"),
                    Consumer.init(id: 1, email: "abc@gmail.com", name: "王大寶", dateOfBirth: "2001/20/34", mobilePhone: "0912345678", address: "12342 road", gender: 1, storeId: 1, consumerNumber: "23234", serialNumber: "A121919743"),
                    Consumer.init(id: 1, email: "abc@gmail.com", name: "王大寶", dateOfBirth: "2001/20/34", mobilePhone: "0912345678", address: "12342 road", gender: 1, storeId: 1, consumerNumber: "23234", serialNumber: "A121919743")]
        setupLayout()

//            NetworkManager.fetchElectronicDocs() { (electronicDocs) in
//                self.electronicDocs = electronicDocs
//                DispatchQueue.main.async {
//                    self.electronicDocTableView.reloadData()
//                }
//            }
    }
    
    private func setupLayout() {
        consumerTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        consumerTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        consumerTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        consumerTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}
extension ConsumerSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "consumer", for: indexPath) as! ConsumerCell
        cell.name = consumers[indexPath.row].name
        cell.mobilePhone = consumers[indexPath.row].mobilePhone
        cell.layoutSubviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let electronicDetailVC = ElectronicDocDetailViewController()
//            electronicDetailVC.fileUrl = electronicDocs[indexPath.row].fileUrl
//            self.navigationController?.pushViewController(electronicDetailVC, animated: true)
    }
}
