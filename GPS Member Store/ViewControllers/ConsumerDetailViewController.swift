//
//  ConsumerDetailViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/28.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit


class ConsumerDetailViewController: UIViewController {
    var id : Int?
    var consumer = Consumer.init(id: 0, name: "", mobilePhone: "", dateOfBirth: "", serialNumber: "", email: "", address: "", gender: 0, storeId: 0, tags: [])
    
    lazy var infoTableView : UITableView = {
        var tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FormCell.self, forCellReuseIdentifier: "form")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "顧客資料"
        view.addSubview(infoTableView)
        infoTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()
    }
    
    private func setupLayout() {
        if let id = id {
//            NetworkManager.fetchConsumer(id: id) { (fetchedConsumer) in
//                self.consumer = fetchedConsumer
//                DispatchQueue.main.async {
//                    self.infoTableView.reloadData()
//                }
//            }
            self.consumer = Consumer.init(id: id, name: "王大寶", mobilePhone: "0923233344", dateOfBirth: "1970/01/01", serialNumber: "A129233444", email: "abc@123.com", address: "台北市大同區", gender: 1, storeId: 1, tags: ["心臟病", "高血壓", "中風"])
        }

        infoTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        infoTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        infoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        
    }
    
    @objc private func saveButtonTapped(sender: UIButton!) {

    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
            let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
            cell1.answerField.text = "\(year)年\(month)月\(day)日"

        }
    }
}

extension ConsumerDetailViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
        cell.selectionStyle = .none
        switch indexPath.row {
            case 0:
                cell.field = "姓名："
                cell.answer = consumer.name
                cell.fieldType = FieldType.DisplayOnly
            case 1:
                cell.field = "出生日期："
                cell.answer = consumer.dateOfBirth
                cell.fieldType = FieldType.DisplayOnly
            case 2:
                cell.field = "身份證字號："
                cell.answer = consumer.serialNumber
                cell.fieldType = FieldType.DisplayOnly
            case 3:
                cell.field = "手機號碼："
                cell.answer = consumer.mobilePhone
                cell.fieldType = FieldType.DisplayOnly
            case 4:
                cell.field = "電子郵件："
                cell.answer = consumer.email
                cell.fieldType = FieldType.DisplayOnly
            case 5:
                cell.field = "住址："
                cell.answer = consumer.address
                cell.fieldType = FieldType.DisplayOnly
            case 6:
                cell.field = "性別："
                cell.fieldType = FieldType.DisplayOnly
                switch consumer.gender {
                case 1:
                    cell.answer = "男性"
                default:
                    cell.answer = "女性"
                }
                cell.fieldType = FieldType.DisplayOnly
            case 7:
                cell.field = "標籤："
                cell.answer = "#心臟病 #高血壓 #中風"
                cell.fieldType = FieldType.Navigate
//            case 8:
//                cell.field = "血壓血糖紀錄"
//                cell.fieldType = FieldType.Navigate
            default:
                cell.field = ""
        }
        cell.layoutSubviews()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                break
            case 1:
                break
            case 2:
                break
            case 3:
                break
            case 4:
                break
            case 5:
                break
            case 6:
                break
            case 7:
                let tagsVC = TagsViewController()
                tagsVC.tagsString = "#心臟病 #高血壓 #中風"
                self.navigationController?.pushViewController(tagsVC, animated: true)
                break
            default:
                break
        }
    }
}

extension ConsumerDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 2
        }
        return 0
    }

    func pickerView(_ f: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row == 0 {
                return "男性"
            }
            return "女性"
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell4 = infoTableView.cellForRow(at: NSIndexPath(row: 4, section: 0) as IndexPath) as! FormCell
        if row == 0 {
            cell4.answerField.text = "男性"
        }
        else {
            cell4.answerField.text = "女性"
        }
        self.view.endEditing(true)
    }

}
