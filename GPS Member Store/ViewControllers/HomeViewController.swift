//
//  HomeViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/19.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo_gps_horizontal")
        return imageView
    }()
    
    var storeLabel : UITextField = {
        let label =  UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = UIFont(name: "PingFangTC-Medium", size: 28)
        label.textColor = ATLANTIS_GREEN
        label.text = "松仁藥局"
        return label
    }()
    
    var separator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor .black
        view.alpha = 0.2
        return view
    }()

    lazy var functionCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let itemWidth = (UIScreen.main.bounds.width - 80) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 35)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FunctionCell.self, forCellWithReuseIdentifier: "function")
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        if (self.accountTableView.indexPathForSelectedRow != nil) {
//            self.accountTableView.deselectRow(at: self.accountTableView.indexPathForSelectedRow!, animated: true)
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        view.addSubview(logoImageView)
        view.addSubview(storeLabel)
        view.addSubview(separator)
        view.addSubview(functionCollectionView)
        setupLayout()
    }
    
    private func setupLayout() {
        logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 53).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 87).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        storeLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 16).isActive = true
        storeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        storeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        storeLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        separator.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 8).isActive = true
        separator.topAnchor.constraint(equalTo: view.topAnchor, constant: 52).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 30).isActive = true

        functionCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        functionCollectionView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).isActive = true
        functionCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        functionCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9;
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "function", for: indexPath) as! FunctionCell
        switch indexPath.row {
        case 0:
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_1")
            cell.name = "電子帳單"
            break
        case 1:
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_2")
            cell.name = "電子公文"
            break
        case 2:
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_3")
            cell.name = "庫存調查"
            break
        case 3:
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_4")
            cell.name = "銷貨單"
            break
        case 4:
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_5")
            cell.name = "訂貨系統"
            break
        case 5:
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_6")
            cell.name = "商品批價"
            break
        case 6:
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_7")
            cell.name = "更改密碼"
            break
        case 7:
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_8")
            cell.name = "QR Code"
            break
        case 8:
            cell.mainImage = #imageLiteral(resourceName: "Member_Store_Main_9")
            cell.name = "登出"
            break
        default:
            break
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
                QRCodeButtonTapped()
            case 8:
                GlobalVariables.showAlertWithOptions(title: "登出", message: "確定要登出", confirmString: "登出", vc: self) {
                    print("已登出")
                    NotificationCenter.default.post(name: Notification.Name("Logout"), object: nil)
                }
                break
            default:
                break
        }
    }
}
