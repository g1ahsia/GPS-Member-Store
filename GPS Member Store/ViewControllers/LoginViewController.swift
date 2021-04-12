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
        textLabel.textColor = MYTLE
        textLabel.text = "會員店 - 工作人員登入"
        return textLabel
    }()
    
    var subHeaderLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textAlignment = .center
        textLabel.textColor = MYTLE
        textLabel.text = "登入好藥坊，成為好鄰居"
        textLabel.isHidden = true
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

    var invisibleView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        return view
    }()
    
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
    
    var versionLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        label.textAlignment = .right
        label.textColor = MYTLE
        return label
    }()
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        view.addSubview(logoImageView)
        view.addSubview(headerLabel)
        view.addSubview(subHeaderLabel)
        view.addSubview(accountTableView)
        view.addSubview(forgetPassword)
        view.addSubview(login)
        view.addSubview(versionLabel)
        view.addSubview(invisibleView)
        setupLayout()
        
        hideKeyboardWhenTappedOnView()
        
        versionLabel.text = version()
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
        NetworkManager.userLogin(account: cell0.answerField.text!, password: cell1.answerField.text!) { (result) in
            print(result)
            DispatchQueue.main.async {

                if (result["status"] as! Int == 1) {
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: Notification.Name("Initialize"), object: nil)
                        NotificationCenter.default.post(name: Notification.Name("setCookies"), object: nil, userInfo: nil)
                    }
                    let parameters: [String: Any] = [
                        "token" : FCM_TOKEN,
                        "platform" : "ios"
                    ]
                    NetworkManager.registerStoreUserToken(parameters: parameters) { (result) in
                        if (result["status"] as! Int == 1) {
                            print("fcm token added")
                        }
                    }

                }
                else if (result["status"] as! Int == -1) {
                    GlobalVariables.showAlert(title: "登入", message: ERR_CONNECTING, vc: self)
                }
                else {
                    GlobalVariables.showAlert(title: "登入", message: result["message"] as? String, vc: self)
                }
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
        accountTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        accountTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        accountTableView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        subHeaderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subHeaderLabel.bottomAnchor.constraint(equalTo: accountTableView.topAnchor, constant: -30).isActive = true
        subHeaderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: subHeaderLabel.topAnchor, constant: -11).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true

        invisibleView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        invisibleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        invisibleView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        invisibleView.bottomAnchor.constraint(equalTo: headerLabel.topAnchor).isActive = true

        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: invisibleView.centerYAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 61).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 81).isActive = true

        forgetPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgetPassword.topAnchor.constraint(equalTo: accountTableView.bottomAnchor, constant: 20).isActive = true
        forgetPassword.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        login.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        login.topAnchor.constraint(equalTo: forgetPassword.bottomAnchor, constant: 20).isActive = true
        login.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        login.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
