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
    var purpose : ConsumerSearchPurpose?
    var points : Int?

    var consumerSearchBar : UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "關鍵字搜尋客戶"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.setShowsCancelButton(false, animated: true)
        return searchBar
    }()

    lazy var consumerTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConsumerCell.self, forCellReuseIdentifier: "consumer")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var noResult : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        textLabel.textColor = .black
        textLabel.clipsToBounds = true;
        textLabel.textAlignment = .center
        textLabel.text = "查無結果"
        textLabel.isHidden = true
        return textLabel
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
        view.addSubview(consumerSearchBar)
        view.addSubview(consumerTableView)
        view.addSubview(noResult)
        consumerSearchBar.delegate = self
        consumerTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()

//            NetworkManager.fetchElectronicDocs() { (electronicDocs) in
//                self.electronicDocs = electronicDocs
//                DispatchQueue.main.async {
//                    self.electronicDocTableView.reloadData()
//                }
//            }
        
        hideKeyboardWhenTappedOnView()
    }
    
    private func setupLayout() {
        consumerSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        consumerSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6).isActive = true
        consumerSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        consumerSearchBar.heightAnchor.constraint(equalToConstant: 36).isActive = true

        consumerTableView.topAnchor.constraint(equalTo: consumerSearchBar.bottomAnchor, constant: 8).isActive = true
        consumerTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        consumerTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        consumerTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        noResult.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResult.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
        if (purpose == ConsumerSearchPurpose.LookUp) {
            let consumerDetailVC = ConsumerDetailViewController()
            consumerDetailVC.id = consumers[indexPath.row].id
            consumerDetailVC.mobilePhone = consumers[indexPath.row].mobilePhone
            self.navigationController?.pushViewController(consumerDetailVC, animated: true)
        }
        else if (purpose == ConsumerSearchPurpose.SendPoints) {
            let rewardCardsVC = RewardCardsViewController()
            rewardCardsVC.purpose = purpose
            rewardCardsVC.points = points
            rewardCardsVC.id = consumers[indexPath.row].id
            self.navigationController?.pushViewController(rewardCardsVC, animated: true)
        }
        else {
            let messageComposeVC = self.presentingViewController as! MessageComposeViewController
            messageComposeVC.consumer = consumers[indexPath.row]
            messageComposeVC.updateCosumer()
            self.dismiss(animated: true) {
            }
        }
    }
}

extension ConsumerSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        if (searchText.count == 0) {
            consumers = []
            consumerTableView.reloadData()
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        NetworkManager.searchConsumer(keyword: searchBar.text!) { (consumers) in
            DispatchQueue.main.async {
                self.consumers = consumers
                self.consumerTableView.reloadData()
                if (consumers.count > 0) {
                    self.noResult.isHidden = true
                }
                else {
                    self.noResult.isHidden = false
                }
            }
        }
        
    }
}
