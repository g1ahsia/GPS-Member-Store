//
//  ProductSearchResultViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/21.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit

class ProductSearchResultViewController: UIViewController {
    var keywoard = String()
    var products = [Product]()
    var cachedImages = [Int: UIImage]()

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
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if (self.productTableView.indexPathForSelectedRow != nil) {
            self.productTableView.deselectRow(at: self.productTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(productTableView)
        view.addSubview(noResult)
        view.backgroundColor = SNOW
        title = "搜尋結果"
        productTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()
        NetworkManager.fetchProducts(keyword : keywoard) { (products) in
            self.products = products
            DispatchQueue.main.async {
                self.productTableView.reloadData()
                if (products.count > 0) {
                    for index in 0...products.count - 1 {
                        let productId = self.products[index].id
                        let thumbnailUrl = self.products[index].thumbnailUrl
                        DispatchQueue.main.async {
                            if let url = thumbnailUrl {
                                if (url != "") {
                                    self.loadImages(url, indexPath: NSIndexPath(row: index, section: 0) as IndexPath, messageId: productId)
                                }
                            }
                        }
                    }
                    self.noResult.isHidden = true
                }
                else {
                    self.noResult.isHidden = false
                }
            }
        }
    }
    
    private func setupLayout() {

        productTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        productTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        productTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        productTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        noResult.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResult.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
    func loadImages(_ urlString: String, indexPath: IndexPath, messageId : Int) {
        print("loading images for cell " + String(indexPath.row))
            let url = URL(string: urlString)!
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
                            let loc = self.productTableView.contentOffset
                            self.productTableView.beginUpdates()
                            self.productTableView.reloadRows(at: [indexPath], with: .none)
                            self.productTableView.contentOffset = loc
                            self.productTableView.endUpdates()
                        })
                    })

                }
            }
        })
        downloadTask.resume()
    }
}

extension ProductSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath) as! ProductCell
        cell.name = products[indexPath.row].name
        cell.mainImage = self.cachedImages[products[indexPath.row].id]
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
