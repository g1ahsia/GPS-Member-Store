//
//  LoginViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/4.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    var logoImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true;
        imageView.image = #imageLiteral(resourceName: "logo_gps")
        return imageView
    }()
    var headerLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Medium", size: 28)
        textLabel.textAlignment = .center
        textLabel.text = "會員登入"
        return textLabel
    }()
    var subHeaderLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textAlignment = .center
        textLabel.text = "登入好藥坊，成為好鄰居"
        return textLabel
    }()
    
    lazy var accountTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.register(FormCell.self, forCellReuseIdentifier: "form")
        return tableView

    }()

//    var separator3 : UIView = {
//        var view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = BLACKAlpha20
//        return view
//    }()
    var forgetPassword : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("忘記密碼", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        button.addTarget(self, action: #selector(forgetPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    var login : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("送出", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
//    var registration : UIButton = {
//        var button =  UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("註冊會員", for: .normal)
//        button.setTitleColor(ATLANTIS_GREEN, for: .normal)
//        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
//        button.backgroundColor = PATTENS_BLUE
//        button.layer.cornerRadius = 10;
//        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
//        return button
//    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        self.view.addSubview(logoImageView)
        self.view.addSubview(headerLabel)
        self.view.addSubview(subHeaderLabel)
        self.view.addSubview(accountTableView)
//        self.view.addSubview(accountTitle)
//        self.view.addSubview(passwordTitle)
//        self.view.addSubview(account)
//        self.view.addSubview(password)
//        self.view.addSubview(separator1)
//        self.view.addSubview(separator2)
        self.view.addSubview(forgetPassword)
        self.view.addSubview(login)
//        self.view.addSubview(separator3)
//        self.view.addSubview(registration)

        self.setupLayout()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

    }
    
    @objc private func menuButtonTapped(sender: UIButton!) {
        print("haha")

    }
    @objc private func forgetPasswordButtonTapped(sender: UIButton!) {
        print("forget password tapped")
        let forgetPasswordVC = ForgetPasswordViewController()
        self.navigationController?.pushViewController(forgetPasswordVC, animated: true)

        
//        self.dismiss(animated: true) {
//        }

    }
    @objc private func loginButtonTapped(sender: UIButton!) {
        let cell0 = accountTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
        let cell1 = accountTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
//        if (!GlobalVariables.validateMobile(phoneNum: cell0.answerField.text)) {
//            GlobalVariables.showAlert(title: title, message: ERR_INCORRECT_PHONE_NUMBER_FORMAT, vc: self)
//            return
//        }
        
        NetworkManager.login(account: cell0.answerField.text!, password: cell1.answerField.text!) { (result) in
            print(result)
            DispatchQueue.main.async {

//                if (result["status"] as! Int == 1) {
                    self.dismiss(animated: true) {
                    }
//                }
//                else {
//                    GlobalVariables.showAlert(title: "登入", message: result["message"] as? String, vc: self)
//                }
            }
        }


    }
//    @objc private func registrationButtonTapped(sender: UIButton!) {
//        let registrationVC = RegistrationViewController()
//        self.navigationController?.pushViewController(registrationVC, animated: true)
//
//    }
    @objc private func cancelButtonTapped(sender: UIButton!) {
        self.dismiss(animated: true) {
        }
    }

    private func setupLayout() {
        

        
        accountTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        accountTableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        accountTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        accountTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        accountTableView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        subHeaderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subHeaderLabel.bottomAnchor.constraint(equalTo: accountTableView.topAnchor, constant: -30).isActive = true
        subHeaderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: subHeaderLabel.topAnchor, constant: -11).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true

        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: headerLabel.topAnchor, constant: -60).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 61).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 81).isActive = true

//        accountTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        accountTitle.topAnchor.constraint(equalTo: subHeaderLabel.bottomAnchor, constant: 44).isActive = true
//        accountTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        separator1.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        separator1.topAnchor.constraint(equalTo: accountTitle.bottomAnchor, constant: 16).isActive = true
//        separator1.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        separator1.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//
//        passwordTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        passwordTitle.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 14).isActive = true
//        passwordTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        account.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 68).isActive = true
//        account.topAnchor.constraint(equalTo: accountTitle.topAnchor).isActive = true
//        account.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
//        account.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        password.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 68).isActive = true
//        password.topAnchor.constraint(equalTo: passwordTitle.topAnchor).isActive = true
//        password.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
//        password.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        separator2.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        separator2.topAnchor.constraint(equalTo: passwordTitle.bottomAnchor, constant: 16).isActive = true
//        separator2.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        separator2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        forgetPassword.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        forgetPassword.topAnchor.constraint(equalTo: accountTableView.bottomAnchor, constant: 20).isActive = true
        forgetPassword.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
//        send.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        login.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        login.topAnchor.constraint(equalTo: forgetPassword.bottomAnchor, constant: 20).isActive = true
//        send.widthAnchor.constraint(equalToConstant: 335).isActive = true
        login.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        login.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
//        separator3.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        separator3.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 30).isActive = true
//        separator3.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        separator3.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

//        registration.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        registration.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
//        registration.topAnchor.constraint(equalTo: separator3.bottomAnchor, constant: 30).isActive = true
////        registration.widthAnchor.constraint(equalToConstant: 335).isActive = true
//        registration.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
//        registration.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }

}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
        switch indexPath.row {
            case 0:
                cell.field = "帳號："
                cell.placeholder = "請輸入手機號碼"
                cell.fieldType = FieldType.Number
            case 1:
                cell.field = "密碼："
                cell.placeholder = "請輸入密碼"
                cell.fieldType = FieldType.Password
            default:
                cell.field = ""
        }
        cell.layoutSubviews()
        return cell
    }
}
