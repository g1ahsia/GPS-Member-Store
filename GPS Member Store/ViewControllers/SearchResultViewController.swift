//
//  SearchResultViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/21.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    var products = [Product]()

    lazy var productTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: "product")
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(productTableView)
        view.backgroundColor = SNOW
        title = "搜尋結果"
        setupLayout()
        NetworkManager.fetchProducts() { (products) in
            self.products = products
            DispatchQueue.main.async {
                self.productTableView.reloadData()
            }
        }
    }
    
    private func setupLayout() {

        productTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        productTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        productTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        productTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 232
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath) as! ProductCell
        cell.selectionStyle = .none

        return cell
    }
}
