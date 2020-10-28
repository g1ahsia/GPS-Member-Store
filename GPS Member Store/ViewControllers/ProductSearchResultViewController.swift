//
//  ProductSearchResultViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/21.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit

class ProductSearchResultViewController: UIViewController {
    
    var products = [Product]()

    lazy var productTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 110
        tableView.register(ProductCell.self, forCellReuseIdentifier: "product")
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if (self.productTableView.indexPathForSelectedRow != nil) {
            self.productTableView.deselectRow(at: self.productTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(productTableView)
        view.backgroundColor = SNOW
        title = "搜尋結果"
        productTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()
        NetworkManager.fetchProducts(keyword : "糖尿病") { (products) in
            self.products = products
            DispatchQueue.main.async {
                self.productTableView.reloadData()
            }
        }
//        products = [
//            Product.init(id : 1, storeId : 1, isPublic : true, name: "金固強優敏複方膠囊教育版10903 ", description: "內部教育資料，請勿外流。", barcode: "aaaaa", videoUrl : "https://d1een0o27yi8f5.cloudfront.net/video/kinguchiang-education-10903.mp4", pdfUrl : "https://d1.awsstatic.com/whitepapers/Migration/amazon-aurora-migration-handbook.pdf?did=wp_card&trk=wp_card", imageUrls : [], thumbnailUrl : "")
//        ]
    }
    
    private func setupLayout() {

        productTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        productTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        productTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        productTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}

extension ProductSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath) as! ProductCell
//        cell.selectionStyle = .none
        cell.name = products[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = ProductDetailViewController()
        NetworkManager.fetchProduct(id : products[indexPath.row].id) { (product) in
            productDetailVC.name = product.name
            productDetailVC.desc = product.description
            productDetailVC.videoUrl = product.videoUrl
            productDetailVC.pdfUrl = product.pdfUrl
            productDetailVC.imageUrls = product.imageUrls

            DispatchQueue.main.async {

                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
        }
    }
}
