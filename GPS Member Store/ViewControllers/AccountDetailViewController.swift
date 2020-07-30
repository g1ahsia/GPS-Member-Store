//
//  AccountDetailViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/15.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class AccountDetailViewController: UIViewController {

    lazy var infoTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FormCell.self, forCellReuseIdentifier: "form")
        return tableView
    }()

    var datePicker : UIDatePicker = {
        var picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.datePickerMode = .date
        picker.alpha = 0
        return picker
    }()
    
    lazy var sexPickerView : UIPickerView = {
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.alpha = 0
        picker.delegate = self
        return picker
    }()
    
    var save : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("確認修改", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.alpha = 0.50
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "修改個人資料"
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        view.addSubview(infoTableView)
        view.addSubview(save)
        infoTableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(datePicker)
        view.addSubview(sexPickerView)

        setupLayout()

    }
    
    private func setupLayout() {
        infoTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        infoTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        infoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        sexPickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        sexPickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        sexPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        save.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        save.topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 30).isActive = true
        save.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        save.heightAnchor.constraint(equalToConstant: 44).isActive = true
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

extension AccountDetailViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
        cell.selectionStyle = .none
        cell.answerField.delegate = self
        switch indexPath.row {
            case 0:
                cell.field = "姓名："
                cell.placeholder = "請輸入完整姓名"
                cell.fieldType = FieldType.Text
            case 1:
                cell.field = "出生日期："
                cell.placeholder = "請輸入出生日期"
                cell.fieldType = FieldType.Selection
            case 2:
                cell.field = "電子郵件："
                cell.placeholder = "請填寫電子郵件"
                cell.fieldType = FieldType.Email
            case 3:
                cell.field = "住址："
                cell.placeholder = "請填寫住址"
                cell.fieldType = FieldType.Text
            case 4:
                cell.field = "性別："
                cell.placeholder = "請選擇性別"
                cell.fieldType = FieldType.Selection
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
                datePicker.alpha = 1
                sexPickerView.alpha = 0
                self.view.endEditing(true)
                break
            case 2:
                break
            case 3:
                break
            case 4:
                sexPickerView.alpha = 1
                datePicker.alpha = 0
                self.view.endEditing(true)
                break
            default:
                break
            }
    }
}

extension AccountDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 2
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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

extension AccountDetailViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker.alpha = 0
        sexPickerView.alpha = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return true
    }
}
