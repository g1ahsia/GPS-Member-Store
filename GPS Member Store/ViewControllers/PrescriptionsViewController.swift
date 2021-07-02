//
//  PrescriptionsViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2021/6/12.
//  Copyright © 2021 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class PrescriptionsViewController: UIViewController, UISearchBarDelegate {
    var unProcessedPrescriptions = [Prescription]()
    var processedPrescriptions = [Prescription]()

    let button1 = UIButton()
    let button2 = UIButton()
    let buttonSelector = UIView()
    
    var mainScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 0)
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    lazy var menuView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PATTENS_BLUE
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var unproccessedPrescriptionTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MissionCell.self, forCellReuseIdentifier: "prescription")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var proccessedPrescriptionTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MissionCell.self, forCellReuseIdentifier: "prescription")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
        unProcessedPrescriptions = []
        processedPrescriptions = []

        NetworkManager.fetchPrescriptions(keyword : "") { (prescriptions) in
            DispatchQueue.main.async {
                for prescription in prescriptions {
                    if (prescription.status == 0) {
                        self.unProcessedPrescriptions.append(prescription)
                    }
                    else {
                        self.processedPrescriptions.append(prescription)
                    }
                }
                self.unproccessedPrescriptionTableView.reloadData()
                self.proccessedPrescriptionTableView.reloadData()

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        title = "處方箋"

        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setTitle("未處理", for: .normal)
        button1.setTitleColor(SHUTTLE_GREY, for: .normal)
        button1.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button1.backgroundColor = .clear
        button1.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)

        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("已處理", for: .normal)
        button2.setTitleColor(SHUTTLE_GREY, for: .normal)
        button2.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button2.backgroundColor = .clear
        button2.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        mainScrollView.addSubview(unproccessedPrescriptionTableView)
        mainScrollView.addSubview(proccessedPrescriptionTableView)

        menuView.addSubview(buttonSelector)
        menuView.addSubview(button1)
        menuView.addSubview(button2)
        
        productSearchBar.delegate = self

        view.addSubview(productSearchBar)
        view.addSubview(menuView)
        view.addSubview(mainScrollView)
        setupLayout()
        unproccessedPrescriptionTableView.tableFooterView = UIView(frame: .zero)
        proccessedPrescriptionTableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setupLayout() {
        productSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        productSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6).isActive = true
        productSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        productSearchBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        menuView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        menuView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        menuView.topAnchor.constraint(equalTo: productSearchBar.bottomAnchor, constant: 20).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 20).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        unproccessedPrescriptionTableView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        unproccessedPrescriptionTableView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        unproccessedPrescriptionTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        unproccessedPrescriptionTableView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor).isActive = true

        proccessedPrescriptionTableView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        proccessedPrescriptionTableView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor, constant: UIScreen.main.bounds.width * 1).isActive = true
        proccessedPrescriptionTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        proccessedPrescriptionTableView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor).isActive = true

        button1.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier:   1/2).isActive = true
        button1.heightAnchor.constraint(equalTo: menuView.heightAnchor).isActive = true
        button1.leftAnchor.constraint(equalTo: menuView.leftAnchor).isActive = true
        
        button2.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier:   1/2).isActive = true
        button2.heightAnchor.constraint(equalTo: menuView.heightAnchor).isActive = true
        button2.leftAnchor.constraint(equalTo: button1.rightAnchor).isActive = true
        
        buttonSelector.frame = CGRect(x: 2, y: 2, width: (UIScreen.main.bounds.width - 40 - 10)/2, height: 36)
        buttonSelector.backgroundColor = SNOW
        buttonSelector.layer.cornerRadius = 8
        buttonSelector.layer.borderWidth = 0.5
        buttonSelector.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.04).cgColor
        buttonSelector.layer.shadowColor = UIColor .black.cgColor;
        buttonSelector.layer.shadowOpacity = 0.12;
        buttonSelector.layer.shadowOffset = CGSize(width: 0, height: 3)
        buttonSelector.layer.shadowRadius = 10 / 2.0;

    }
    
    @objc private func menuButtonTapped(sender: UIButton!) {
        if (sender == button1) {
            print("button Action 1", sender.buttonType)
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            buttonSelector.frame = CGRect(x: 2, y: 2, width: (UIScreen.main.bounds.width - 40 - 10)/2, height: 36)
        }
        else if (sender == button2) {
            print("button Action 2", sender.buttonType)
            mainScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
            buttonSelector.frame = CGRect(x: 2 + buttonSelector.frame.size.width + 2, y: 2, width: (UIScreen.main.bounds.width - 40 - 10)/2, height: 36)

        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)

    }
    
    @objc func reload() {
        unProcessedPrescriptions = []
        processedPrescriptions = []
    
        NetworkManager.fetchPrescriptions(keyword: productSearchBar.text ?? "") { prescriptions in
            DispatchQueue.main.async {
                for prescription in prescriptions {
                    if (prescription.status == 0) {
                        self.unProcessedPrescriptions.append(prescription)
                    }
                    else {
                        self.processedPrescriptions.append(prescription)
                    }
                }
                self.unproccessedPrescriptionTableView.reloadData()
                self.proccessedPrescriptionTableView.reloadData()

            }
        }
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("hehe")

        self.view.endEditing(true)
    }

}


extension PrescriptionsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == unproccessedPrescriptionTableView) {
            return unProcessedPrescriptions.count
//            return 5
        }
        else {
            return processedPrescriptions.count
//            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == unproccessedPrescriptionTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prescription", for: indexPath) as! MissionCell
            cell.name = unProcessedPrescriptions[indexPath.row].patientName
            cell.desc = unProcessedPrescriptions[indexPath.row].createdDate
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_10")
            cell.layoutSubviews()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prescription", for: indexPath) as! MissionCell
            cell.name = processedPrescriptions[indexPath.row].patientName
            cell.desc = processedPrescriptions[indexPath.row].createdDate
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_10")
            cell.layoutSubviews()
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prescriptionVC = PrescriptionViewController()
        
        if (tableView == unproccessedPrescriptionTableView) {
            prescriptionVC.prescriptionId = unProcessedPrescriptions[indexPath.row].id
            self.navigationController?.pushViewController(prescriptionVC, animated: true)
        }
        else {
            prescriptionVC.prescriptionId = processedPrescriptions[indexPath.row].id
            self.navigationController?.pushViewController(prescriptionVC, animated: true)
        }
    }
}


extension PrescriptionViewController: UISearchBarDelegate {
    
    

}
