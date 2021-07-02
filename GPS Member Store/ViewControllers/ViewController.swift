//
//  ViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/24.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit
//import CryptoSwift

class ViewController: UIViewController {
    
    var tabBarCtrl: UITabBarController!
    
    var homeNav = UINavigationController()
    
    var messageNav = UINavigationController()
    
    var requestNav = UINavigationController()
    
    var customTabBarItem3 = UITabBarItem()

    var customTabBarItem4 = UITabBarItem()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                return .darkContent
            } else {
                return .darkContent
            }
        } else {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentLoginVC(notification:)), name: Notification.Name("Logout"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.createTabBarController), name:Notification.Name("createTabBarController"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentMessageDetailVC(notification:)), name: Notification.Name("presentMessageDetailVC"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentRequestDetailVC(notification:)), name: Notification.Name("presentRequestDetailVC"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentPrescriptionVC(notification:)), name: Notification.Name("presentPrescriptionVC"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.presentElectronicDocVC(notification:)), name: Notification.Name("presentElectronicDocVC"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentBillVC(notification:)), name: Notification.Name("presentBillVC"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setMessageBadge), name: Notification.Name("setMessageBadge"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearMessageBadge), name: Notification.Name("clearMessageBadge"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.setRequestBadge), name: Notification.Name("setRequestBadge"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearRequestBadge), name: Notification.Name("clearRequestBadge"), object: nil)

        let userDefaults = UserDefaults.standard

        // Read/Get Value
        let myToken = userDefaults.string(forKey: "myToken")
        let myStoreId = userDefaults.string(forKey: "myStoreId")
        let myName = userDefaults.string(forKey: "myName")
        let myPrivilege = userDefaults.array(forKey: "myPrivilege") as? [Int] ?? [Int]()

        if ((myToken) != nil) {
            // Do any additional setup after loading the view.
            TOKEN = myToken!
            STOREID = Int(myStoreId!) ?? 0
            USERNAME = myName!
            PRIVILEGE = myPrivilege
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { // Change `0.05` to the desired number of seconds.
                NotificationCenter.default.post(name: Notification.Name("Logout"), object: nil)
            }
        }
        createTabBarController()
    }
    
    @objc func createTabBarController() {
        tabBarCtrl = UITabBarController()
        tabBarCtrl?.tabBar.tintColor = PIGMENT_GREEN
        
        let homeVC = HomeViewController()
        homeVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        homeNav.navigationBar.tintColor = ATLANTIS_GREEN
        homeNav.setNavigationBarHidden(false, animated: false)
        homeNav.viewControllers.removeAll()
        homeNav.pushViewController(homeVC, animated: true)

        let customTabBarItem:UITabBarItem = UITabBarItem(title: "首頁", image: #imageLiteral(resourceName: " tab_ic_home_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_home_green"))
        homeNav.tabBarItem = customTabBarItem

        let productSearchVC = ProductSearchViewController()
        productSearchVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let productSearchNav = UINavigationController()
        productSearchNav.navigationBar.tintColor = ATLANTIS_GREEN
        productSearchNav.setNavigationBarHidden(false, animated: false)
        productSearchNav.pushViewController(productSearchVC, animated: true)
        let customTabBarItem2:UITabBarItem = UITabBarItem(title: "產品播放", image: #imageLiteral(resourceName: " tab_ic_search_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_search_green"))
        productSearchNav.tabBarItem = customTabBarItem2
        
        let requestVC = RequestViewController()
        requestVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let messageVC = MessageViewController()
        messageVC.role = Role.MemberStore
        messageVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        messageNav = UINavigationController()
        messageNav.navigationBar.tintColor = ATLANTIS_GREEN
        messageNav.setNavigationBarHidden(false, animated: false)
        messageNav.pushViewController(messageVC, animated: true)
        customTabBarItem3 = UITabBarItem(title: "會員訊息", image: #imageLiteral(resourceName: " tab_ic_messages_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_messages_green"))
        messageNav.tabBarItem = customTabBarItem3
        
        requestNav = UINavigationController()
        requestNav.navigationBar.tintColor = ATLANTIS_GREEN
        requestNav.setNavigationBarHidden(false, animated: false)
        requestNav.pushViewController(requestVC, animated: true)
        customTabBarItem4 = UITabBarItem(title: "調撥平台", image: #imageLiteral(resourceName: " tab_ic_truck_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_truck_green"))
        requestNav.tabBarItem = customTabBarItem4

        let consumerSearchVC = ConsumerSearchViewController()
        consumerSearchVC.purpose = ConsumerSearchPurpose.LookUp
        consumerSearchVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let consumerSearchNav = UINavigationController()
        consumerSearchNav.navigationBar.tintColor = ATLANTIS_GREEN
        consumerSearchNav.setNavigationBarHidden(false, animated: false)
        consumerSearchNav.pushViewController(consumerSearchVC, animated: true)

        let customTabBarItem5:UITabBarItem = UITabBarItem(title: "客戶搜尋", image: #imageLiteral(resourceName: " tab_ic_users_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_users_green"))
        consumerSearchNav.tabBarItem = customTabBarItem5
                
        var tabBarFunctions = [homeNav, productSearchNav, messageNav, requestNav, consumerSearchNav]
        
        if (!PRIVILEGE.contains(5)) {
            if let index = tabBarFunctions.firstIndex(of: consumerSearchNav) {
                tabBarFunctions.remove(at: index)
            }
        }
        if (!PRIVILEGE.contains(7)) {
            if let index = tabBarFunctions.firstIndex(of: productSearchNav) {
                tabBarFunctions.remove(at: index)
            }
        }
        if (!PRIVILEGE.contains(14)) {
            if let index = tabBarFunctions.firstIndex(of: messageNav) {
                tabBarFunctions.remove(at: index)
            }
        }
        if (!PRIVILEGE.contains(15)) {
            if let index = tabBarFunctions.firstIndex(of: requestNav) {
                tabBarFunctions.remove(at: index)
            }
        }
        tabBarCtrl.viewControllers = tabBarFunctions

        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }

        self.view.addSubview(tabBarCtrl.view)

    }

    @objc func presentLoginVC(notification: Notification) {
        let loginVC = LoginViewController()
        loginVC.view.backgroundColor = .white

        let loginNav = UINavigationController()
        loginNav.navigationBar.tintColor = ATLANTIS_GREEN
        loginNav.modalPresentationStyle = .fullScreen
        loginNav.pushViewController(loginVC, animated: true)
        self.present(loginNav, animated: false) {
            self.tabBarCtrl?.selectedIndex = 0
        }
    }
    
    @objc func presentMessageDetailVC(notification: Notification) {
        tabBarCtrl.selectedIndex = 2
        let userInfo = notification.userInfo;
        let messageDetailVC = MessageDetailViewController()
        messageDetailVC.role = Role.MemberStore
        
        let threadId = (userInfo?["threadId"] as! NSString).integerValue
        let threadType = (userInfo?["threadType"] as! NSString).integerValue

        messageDetailVC.title = MESSAGE_SUBJECTS[threadType - 1]
        messageDetailVC.threadId = threadId
        messageDetailVC.reloadData()
        messageNav.popToRootViewController(animated: true)
        messageNav.pushViewController(messageDetailVC, animated: true)
    }

    @objc func presentRequestDetailVC(notification: Notification) {
        tabBarCtrl.selectedIndex = 3
        let userInfo = notification.userInfo;
        let threadId = (userInfo?["threadId"] as! NSString).integerValue

        NetworkManager.fetchRequest(threadId: threadId) { (request) in
            DispatchQueue.main.async {
                let requestDetailVC = RequestDetailViewController()
                requestDetailVC.title = REQUEST_SUBJECTS[request.typeId - 1]
                requestDetailVC.request = request
                requestDetailVC.threadId = request.id
                requestDetailVC.reloadData()
                self.requestNav.popToRootViewController(animated: true)
                self.requestNav.pushViewController(requestDetailVC, animated: true)
            }
        }
    }
    
    @objc func presentPrescriptionVC(notification: Notification) {
        tabBarCtrl.selectedIndex = 0
        let userInfo = notification.userInfo;
        let prescriptionId = (userInfo?["prescriptionId"] as! NSString).integerValue
        let prescriptionVC = PrescriptionViewController()
        prescriptionVC.prescriptionId = prescriptionId
        self.homeNav.popToRootViewController(animated: true)
        self.homeNav.pushViewController(prescriptionVC, animated: true)
    }

    
    @objc func presentElectronicDocVC(notification: Notification) {
        let userInfo = notification.userInfo;
        let fileUrl = userInfo?["fileUrl"] as! String
        let pdfVC = PDFViewController()
        pdfVC.fileUrl = fileUrl
        pdfVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(pdfVC, animated: true)
    }

    @objc func presentBillVC(notification: Notification) {
        
    }
    @objc func setMessageBadge() {
        if (BADGES[4] > 0) {
            let badge_message = String(BADGES[4])
            customTabBarItem3.badgeValue = badge_message
        }
    }
    @objc func setRequestBadge() {
        if (BADGES[5] > 0) {
            let badge_request = String(BADGES[5])
            customTabBarItem4.badgeValue = badge_request
        }
    }
    @objc func clearMessageBadge() {
//        let badge_message = ""
        customTabBarItem3.badgeValue = nil
        
    }
    @objc func clearRequestBadge() {
//        let badge_request = ""
        customTabBarItem4.badgeValue = nil
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedOnView() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
