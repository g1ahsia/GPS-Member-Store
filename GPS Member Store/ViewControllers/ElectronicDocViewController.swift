//
//  ElectronicDocViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/28.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class ElectronicDocViewController: UIViewController {
    var electronicDocs = [ElectronicDoc]()

    lazy var electronicDocTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ElectronicDocCell.self, forCellReuseIdentifier: "electronicDoc")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        if (self.electronicDocTableView.indexPathForSelectedRow != nil) {
            self.electronicDocTableView.deselectRow(at: self.electronicDocTableView.indexPathForSelectedRow!, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        title = "電子公文"
        view.addSubview(electronicDocTableView)
        electronicDocTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()

        NetworkManager.fetchElectronicDocs() { (electronicDocs) in
            self.electronicDocs = electronicDocs
            DispatchQueue.main.async {
                self.electronicDocTableView.reloadData()
            }
        }
    }
    
    private func setupLayout() {
        electronicDocTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        electronicDocTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        electronicDocTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        electronicDocTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}

extension ElectronicDocViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return electronicDocs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "electronicDoc", for: indexPath) as! ElectronicDocCell
        cell.fileUrl = electronicDocs[electronicDocs.count - indexPath.row - 1].fileUrl
        cell.createdDate = electronicDocs[electronicDocs.count - indexPath.row - 1].createdDate
        cell.layoutSubviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pdfVC = PDFViewController()
        pdfVC.fileUrl = electronicDocs[electronicDocs.count - indexPath.row - 1].fileUrl
        pdfVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(pdfVC, animated: true)
    }
}
