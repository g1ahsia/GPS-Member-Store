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
        createTabBarController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { // Change `0.05` to the desired number of seconds.
            self.presentLoginVC()
        }
    }

    func createTabBarController() {
        tabBarCtrl = UITabBarController()
        tabBarCtrl?.tabBar.tintColor = PIGMENT_GREEN

        let productSearchVC = ProductSearchViewController()
        
        let productSearchNav = UINavigationController()
        productSearchNav.navigationBar.tintColor = ATLANTIS_GREEN
        productSearchNav.setNavigationBarHidden(false, animated: false)
        productSearchNav.pushViewController(productSearchVC, animated: true)
        let customTabBarItem1:UITabBarItem = UITabBarItem(title: "產品播放", image: #imageLiteral(resourceName: " tab_ic_search_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_search_green"))
        productSearchNav.tabBarItem = customTabBarItem1
        
        let transferGoodsVC = TransferGoodsViewController()
        
        let transferGoodsNav = UINavigationController()
        transferGoodsNav.navigationBar.tintColor = ATLANTIS_GREEN
        transferGoodsNav.setNavigationBarHidden(false, animated: false)
        transferGoodsNav.pushViewController(transferGoodsVC, animated: true)
        let customTabBarItem2:UITabBarItem = UITabBarItem(title: "調撥平台", image: #imageLiteral(resourceName: " tab_ic_truck_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_truck_green"))
        transferGoodsNav.tabBarItem = customTabBarItem2
        
        let messageVC = MessageViewController()

        let messageNav = UINavigationController()
        messageNav.navigationBar.tintColor = ATLANTIS_GREEN
        messageNav.setNavigationBarHidden(false, animated: false)
        messageNav.pushViewController(messageVC, animated: true)
        let customTabBarItem3:UITabBarItem = UITabBarItem(title: "會員訊息", image: #imageLiteral(resourceName: " tab_ic_messages_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_messages_green"))
        messageNav.tabBarItem = customTabBarItem3

        let consumerSearchVC = ConsumerSearchViewController()
        
        let consumerSearchNav = UINavigationController()
        consumerSearchNav.navigationBar.tintColor = ATLANTIS_GREEN
        consumerSearchNav.setNavigationBarHidden(false, animated: false)
        consumerSearchNav.pushViewController(consumerSearchVC, animated: true)

//        storeVC.view.backgroundColor = .blue
        let customTabBarItem4:UITabBarItem = UITabBarItem(title: "客戶搜尋", image: #imageLiteral(resourceName: " tab_ic_users_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_users_green"))
        consumerSearchNav.tabBarItem = customTabBarItem4
        
        let accountVC = AccountViewController()
        
        let accountNav = UINavigationController()
        accountNav.navigationBar.tintColor = ATLANTIS_GREEN
        accountNav.setNavigationBarHidden(false, animated: false)
        accountNav.pushViewController(accountVC, animated: true)
        
        let customTabBarItem5:UITabBarItem = UITabBarItem(title: "我的帳號", image: #imageLiteral(resourceName: " tab_ic_user_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_user_green"))
        accountNav.tabBarItem = customTabBarItem5

        tabBarCtrl.viewControllers = [productSearchNav, transferGoodsNav, messageNav, consumerSearchNav, accountNav]
        
        self.view.addSubview(tabBarCtrl.view)

    }
    func presentLoginVC() {
        let loginVC = LoginViewController()
        loginVC.view.backgroundColor = .white

        let loginNav = UINavigationController()
        loginNav.navigationBar.tintColor = ATLANTIS_GREEN
        loginNav.modalPresentationStyle = .fullScreen
        loginNav.pushViewController(loginVC, animated: true)

        self.present(loginNav, animated: false) {
        }
    }
}

