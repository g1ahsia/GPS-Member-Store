//
//  ProductViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/24.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class ProductSearchViewController: UIViewController {
    
    var productSearchBar : UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "關鍵字搜尋"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.setShowsCancelButton(false, animated: true)
        return searchBar
    }()
    
    lazy var captureBracket : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "barcode_capture"), for: .normal)
        button.addTarget(self, action: #selector(barcodeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var redLine : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = RED
        return view
    }()

    var search : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("確定", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "產品播放系統"
        view.addSubview(productSearchBar)
        view.addSubview(captureBracket)
        view.addSubview(redLine)
        view.addSubview(search)
        productSearchBar.delegate = self
        setupLayout()
    }
    
    private func setupLayout() {
        productSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        productSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6).isActive = true
        productSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        productSearchBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        captureBracket.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureBracket.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        captureBracket.widthAnchor.constraint(equalToConstant: 271).isActive = true
        captureBracket.heightAnchor.constraint(equalToConstant: 183).isActive = true
        
        redLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        redLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        redLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        redLine.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        search.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        search.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        search.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    @objc private func searchButtonTapped() {
        let productSearchResultVC = ProductSearchResultViewController()
        self.navigationController?.pushViewController(productSearchResultVC, animated: true)
    }
    
    @objc private func barcodeButtonTapped(sender: UIButton!) {
        let barcodeScannerVC = BarcodeScannerViewController()
        present(barcodeScannerVC, animated: true)

    }

}

extension ProductSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        let productSearchResultVC = ProductSearchResultViewController()
        self.navigationController?.pushViewController(productSearchResultVC, animated: true)
    }

}
