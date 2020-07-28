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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "account")
        return tableView

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "account", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        
        let imageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 32 - 8, y: (60 - 32)/2, width: 32, height: 32))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true;
        imageView.image = #imageLiteral(resourceName: " arw_right_sm_grey")
        cell.addSubview(imageView)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "電子帳單"
            break
        case 1:
            cell.textLabel?.text = "電子公文"
            break
        case 2:
            cell.textLabel?.text = "庫存調查"
            break
        case 3:
            cell.textLabel?.text = "銷貨單"
            break
        case 4:
            cell.textLabel?.text = "訂貨系統"
        case 5:
            cell.textLabel?.text = "商品批價"
        case 6:
            cell.textLabel?.text = "個人資料"
        case 7:
            cell.textLabel?.text = "登出"
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
                let accountDetailVC = AccountDetailViewController()
                self.navigationController?.pushViewController(accountDetailVC, animated: true)
                break
            case 1:
                let electronicDocVC = ElectronicDocViewController()
                self.navigationController?.pushViewController(electronicDocVC, animated: true)
                break
            case 2:
                break
            case 3:
                break
            case 4:
                GlobalVariables.showAlertWithOptions(title: "登出", message: "確定要登出", confirmString: "登出", vc: self) {
                    print("已登出")
                }
                break
            default:
                break
            }
    }
}
