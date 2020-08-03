//
//  AccountViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/19.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    lazy var accountTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableCell.self, forCellReuseIdentifier: "account")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if (self.accountTableView.indexPathForSelectedRow != nil) {
            self.accountTableView.deselectRow(at: self.accountTableView.indexPathForSelectedRow!, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var image = UIImage(#imageLiteral(resourceName: " ic_qrcode"))
        image = image.withRenderingMode(.alwaysOriginal)
        let customer = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(self.QRCodeButtonTapped)) //
        self.navigationItem.rightBarButtonItem  = customer

        view.backgroundColor = SNOW
        title = "我的帳號"
        view.addSubview(accountTableView)
        accountTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()
    }
    
    private func setupLayout() {
        accountTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        accountTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        accountTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        accountTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "account", for: indexPath) as! TableCell
        
        switch indexPath.row {
        case 0:
            cell.field = "電子帳單"
            break
        case 1:
            cell.field = "電子公文"
            break
        case 2:
            cell.field = "庫存調查"
            break
        case 3:
            cell.field = "銷貨單"
            break
        case 4:
            cell.field = "訂貨系統"
        case 5:
            cell.field = "商品批價"
        case 6:
            cell.field = "更改密碼"
        case 7:
            cell.field = "登出"
            break
        default:
            break
        }
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
                let electronicDocVC = ElectronicDocViewController()
                self.navigationController?.pushViewController(electronicDocVC, animated: true)
                break
            case 2:
                break
            case 3:
                break
            case 6:
                let changePasswordVC = ChangePasswordViewController()
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
                break
            case 7:
                GlobalVariables.showAlertWithOptions(title: "登出", message: "確定要登出", confirmString: "登出", vc: self) {
                    print("已登出")
                    NotificationCenter.default.post(name: Notification.Name("Logout"), object: nil)
                }
                break
            default:
                break
            }
    }
    
    @objc private func QRCodeButtonTapped() {
        let qrCodeVC = QRCodeViewController()
        self.navigationController?.pushViewController(qrCodeVC, animated: true)
    }
}
