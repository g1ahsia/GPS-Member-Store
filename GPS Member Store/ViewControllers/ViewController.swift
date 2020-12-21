//
//  ViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/24.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tabBarCtrl: UITabBarController!
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentLoginVC(notification:)), name: Notification.Name("Logout"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.createTabBarController), name:Notification.Name("Initialize"), object: nil)
        
        let userDefaults = UserDefaults.standard

        // Read/Get Value
        let myToken = userDefaults.string(forKey: "myToken")
        let myStoreId = userDefaults.string(forKey: "myStoreId")
        let myPrivilege = userDefaults.array(forKey: "myPrivilege") as? [Int] ?? [Int]()

        if ((myToken) != nil) {
            // Do any additional setup after loading the view.
            TOKEN = myToken!
            STOREID = Int(myStoreId!) ?? 0
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

        let productSearchVC = ProductSearchViewController()
        productSearchVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let productSearchNav = UINavigationController()
        productSearchNav.navigationBar.tintColor = ATLANTIS_GREEN
        productSearchNav.setNavigationBarHidden(false, animated: false)
        productSearchNav.pushViewController(productSearchVC, animated: true)
        let customTabBarItem1:UITabBarItem = UITabBarItem(title: "產品播放", image: #imageLiteral(resourceName: " tab_ic_search_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_search_green"))
        productSearchNav.tabBarItem = customTabBarItem1
        
        let requestVC = RequestViewController()
        requestVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let requestNav = UINavigationController()
        requestNav.navigationBar.tintColor = ATLANTIS_GREEN
        requestNav.setNavigationBarHidden(false, animated: false)
        requestNav.pushViewController(requestVC, animated: true)
        let customTabBarItem2:UITabBarItem = UITabBarItem(title: "調撥平台", image: #imageLiteral(resourceName: " tab_ic_truck_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_truck_green"))
        requestNav.tabBarItem = customTabBarItem2
        
        let messageVC = MessageViewController()
        messageVC.role = Role.MemberStore
        messageVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let messageNav = UINavigationController()
        messageNav.navigationBar.tintColor = ATLANTIS_GREEN
        messageNav.setNavigationBarHidden(false, animated: false)
        messageNav.pushViewController(messageVC, animated: true)
        let customTabBarItem3:UITabBarItem = UITabBarItem(title: "會員訊息", image: #imageLiteral(resourceName: " tab_ic_messages_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_messages_green"))
        messageNav.tabBarItem = customTabBarItem3

        let consumerSearchVC = ConsumerSearchViewController()
        consumerSearchVC.purpose = ConsumerSearchPurpose.LookUp
        consumerSearchVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let consumerSearchNav = UINavigationController()
        consumerSearchNav.navigationBar.tintColor = ATLANTIS_GREEN
        consumerSearchNav.setNavigationBarHidden(false, animated: false)
        consumerSearchNav.pushViewController(consumerSearchVC, animated: true)

//        storeVC.view.backgroundColor = .blue
        let customTabBarItem4:UITabBarItem = UITabBarItem(title: "客戶搜尋", image: #imageLiteral(resourceName: " tab_ic_users_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_users_green"))
        consumerSearchNav.tabBarItem = customTabBarItem4
        
        let homeVC = HomeViewController()
        homeVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let homeNav = UINavigationController()
        homeNav.navigationBar.tintColor = ATLANTIS_GREEN
        homeNav.setNavigationBarHidden(false, animated: false)
        homeNav.pushViewController(homeVC, animated: true)
        
        let customTabBarItem5:UITabBarItem = UITabBarItem(title: "首頁", image: #imageLiteral(resourceName: " tab_ic_home_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_home_green"))
        homeNav.tabBarItem = customTabBarItem5
        
        var tabBarFunctions = [homeNav, productSearchNav, messageNav, requestNav, consumerSearchNav]
        
        if (!PRIVILEGE.contains(5)) {
            if let index = tabBarFunctions.firstIndex(of: consumerSearchNav) {
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
}

extension UIViewController {
    func hideKeyboardWhenTappedOnView() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
