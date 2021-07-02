//
//  HomeViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/19.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit
import WebKit
import BadgeSwift

class OnShiftWKHTTPCookieStoreObserver: NSObject, WKHTTPCookieStoreObserver {
    @available(iOS 11.0, *)

    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies({(cookies: [HTTPCookie]) in

            cookies.forEach({(cookie: HTTPCookie) in

                print("COOKIE name: \(cookie.name) domain: \(cookie.domain) value: \(cookie.value)")

            })

        })

    }
}


class HomeViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    var features = [Feature]()
    var eBillCell : FunctionCell?
    var eDocsCell : FunctionCell?
    var stockCell : FunctionCell?
    var salesCell : FunctionCell?
    var prescriptionCell : FunctionCell?

    var controller = UIViewController()
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
        let itemWidth = Int((UIScreen.main.bounds.width - 80) / 3)
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

    lazy var webView: WKWebView = {
        let web = WKWebView.init(frame: UIScreen.main.bounds)
        web.configuration.websiteDataStore.httpCookieStore.add(OnShiftWKHTTPCookieStoreObserver())
        web.navigationDelegate = self
        web.uiDelegate = self  //must have this
        web.allowsBackForwardNavigationGestures = false
        web.translatesAutoresizingMaskIntoConstraints = false
        
        return web
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        NetworkManager.fetchStore(id: STOREID) { (fetchedStore) in
            DispatchQueue.main.async {
                self.storeLabel.text = fetchedStore.name
                STORECODE = fetchedStore.code
                self.setCookies()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.presentMainMenu(notification:)), name: Notification.Name("presentMainMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCookies), name: Notification.Name("setCookies"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.searchBarcode(_:)), name: NSNotification.Name(rawValue: "scannedBarcodeForPrice"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchBadges), name: Notification.Name("fetchBadges"), object: nil)
        
        controller = UIViewController()
        controller.view.addSubview(webView)
        controller.modalPresentationStyle = .fullScreen
        controller.view.backgroundColor = SNOW

        view.backgroundColor = SNOW
        view.addSubview(logoImageView)
        view.addSubview(storeLabel)
        view.addSubview(separator)
        view.addSubview(functionCollectionView)
        
        setupLayout()
        fetchBadges()
        
        let userDefaults = UserDefaults.standard

        let myToken = userDefaults.string(forKey: "myToken")
        let myPrivilege = userDefaults.array(forKey: "myPrivilege") as? [Int] ?? [Int]()

        if ((myToken) != nil) {
            PRIVILEGE = myPrivilege
        }

        if (PRIVILEGE.contains(4)) {
            let feature = Feature.init(privilege: 4, name: "電子公文", image: #imageLiteral(resourceName: "Member_Store_Main_1"))
            features.append(feature)
        }

        if (PRIVILEGE.contains(9)) {
            let feature = Feature.init(privilege: 9, name: "電子帳單", image: #imageLiteral(resourceName: "Member_Store_Main_1"))
            features.append(feature)
        }
        if (PRIVILEGE.contains(10)) {
            let feature = Feature.init(privilege: 10, name: "訂貨系統", image: #imageLiteral(resourceName: "Member_Store_Main_5"))
            features.append(feature)
        }
        if (PRIVILEGE.contains(11)) {
            let feature = Feature.init(privilege: 11, name: "庫存調查", image: #imageLiteral(resourceName: "Member_Store_Main_3"))
            features.append(feature)
        }
        if (PRIVILEGE.contains(12)) {
            let feature = Feature.init(privilege: 12, name: "批售價查詢", image: #imageLiteral(resourceName: "Member_Store_Main_6"))
            features.append(feature)
        }
        if (PRIVILEGE.contains(13)) {
            let feature = Feature.init(privilege: 13, name: "銷貨單", image: #imageLiteral(resourceName: "Member_Store_Main_4"))
            features.append(feature)
        }
        if (PRIVILEGE.contains(17)) {
            let feature = Feature.init(privilege: 17, name: "發送點數", image: #imageLiteral(resourceName: "Member_Store_Main_8"))
            features.append(feature)
        }
        if (PRIVILEGE.contains(18)) {
            let feature18 = Feature.init(privilege: 18, name: "處方箋", image: #imageLiteral(resourceName: "Member_Store_Main_10"))
            features.append(feature18)
        }
        let feature1 = Feature.init(privilege: -1, name: "修改密碼", image: #imageLiteral(resourceName: "Member_Store_Main_7"))
        features.append(feature1)

        let feature2 = Feature.init(privilege: -2, name: "登出", image: #imageLiteral(resourceName: "Member_Store_Main_9"))
        features.append(feature2)

        functionCollectionView.reloadData()
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
        
        webView.leftAnchor.constraint(equalTo: controller.view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: controller.view.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
        
    @objc private func fetchBadges() {
        NetworkManager.fetchStoreBadges() {
            DispatchQueue.main.async {
                print(BADGES)
                
//                BADGES = [1, 2, 3, 4, 5, 6, 7]
                
                NotificationCenter.default.post(name: Notification.Name("setMessageBadge"), object: nil, userInfo: nil)
                NotificationCenter.default.post(name: Notification.Name("setRequestBadge"), object: nil, userInfo: nil)
                
                if ((self.eBillCell) != nil) {
                    self.eBillCell!.badgeNum = BADGES[0]
                    self.eBillCell!.layoutSubviews()
                }
                if ((self.eDocsCell) != nil) {
                    self.eDocsCell!.badgeNum = BADGES[1]
                    self.eDocsCell!.layoutSubviews()
                }
                if ((self.stockCell) != nil) {
                    self.stockCell!.badgeNum = BADGES[2]
                    self.stockCell!.layoutSubviews()
                }
                if ((self.salesCell) != nil) {
                    self.salesCell!.badgeNum = BADGES[3]
                    self.salesCell!.layoutSubviews()
                }
                if ((self.prescriptionCell) != nil) {
                    self.prescriptionCell!.badgeNum = BADGES[6]
                    self.prescriptionCell!.layoutSubviews()
                }
                BADGE_MESSAGE = BADGES[0] + BADGES[1] + BADGES[2] + BADGES[3] + BADGES[4] + BADGES[5] + BADGES[6]
                
                UIApplication.shared.applicationIconBadgeNumber = BADGE_MESSAGE
            }
        }
    }

    
    @objc private func setCookies() {
        let user_code_cookie = HTTPCookie(properties: [
            .domain: "apps.youthbio.com.tw",
            .path: "/gps",
            .name: "user_code",
            .value: "ABCDE12345"
        ])!
        let username_cookie = HTTPCookie(properties: [
            .domain: "apps.youthbio.com.tw",
            .path: "/gps",
            .name: "user_name",
            .value: String(describing: USERNAME.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
)
//            .secure: "FALSE",
//            .expires: NSDate(timeIntervalSinceNow: 31556926)po
        ])!
        let vip_id_cookie = HTTPCookie(properties: [
            .domain: "apps.youthbio.com.tw",
            .path: "/gps",
            .name: "vip_id",
            .value: "\(STORECODE)",
//            .secure: "FALSE",
//            .expires: NSDate(timeIntervalSinceNow: 31556926)
        ])!


        webView.configuration.websiteDataStore.httpCookieStore.setCookie(user_code_cookie)
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(username_cookie)
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(vip_id_cookie)
    }
    
    @objc private func QRCodeButtonTapped() {
        let qrCodeVC = QRCodeViewController()
        self.navigationController?.pushViewController(qrCodeVC, animated: true)
    }
    
    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
        fetchBadges()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count;
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "function", for: indexPath) as! FunctionCell
        cell.mainImage = features[indexPath.row].image
        cell.name = features[indexPath.row].name
        
        switch features[indexPath.row].privilege {
        case 9:
            eBillCell = cell
            break
        case 0:
            eDocsCell = cell
            break
        case 11:
            stockCell = cell
            break
        case 13:
            salesCell = cell
            break
        case 18:
            prescriptionCell = cell
            break
        default:
            break
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feature = features[indexPath.row]
        
        switch feature.privilege {
            case 0:
                let electronicDocVC = ElectronicDocViewController()
                self.navigationController?.pushViewController(electronicDocVC, animated: true)
                let param = ["electronicDocs" : 0]
                NetworkManager.updateStoreBadges(parameters: param) { (result) in
                    print(result)
                    self.fetchBadges()
                }
                break
            case 9:
                let url = URL.init(string: "http://apps.youthbio.com.tw/gps/#/e-bill")!
                let request = URLRequest.init(url: url)
                self.navigationController?.pushViewController(controller, animated: true)
                webView.load(request)
                let param = ["bills" : 0]
                NetworkManager.updateStoreBadges(parameters: param) { (result) in
                    print(result)
                    self.fetchBadges()
                }
                break
            case 10:
                let url = URL.init(string: "https://apps.youthbio.com.tw/gps/#/order")!
                let request = URLRequest.init(url: url)
                webView.load(request)
                self.navigationController?.pushViewController(controller, animated: true)
                break
            case 11:
                let url = URL.init(string: "https://apps.youthbio.com.tw/gps/#/stock")!
                let request = URLRequest.init(url: url)
                webView.load(request)
                let param = ["stocks" : 0]
                NetworkManager.updateStoreBadges(parameters: param) { (result) in
                    print(result)
                    self.fetchBadges()
                }
                self.navigationController?.pushViewController(controller, animated: true)
                break
                
            case 12:
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                let url = URL.init(string: "https://apps.youthbio.com.tw/gps/#/commodity")!
                let request = URLRequest.init(url: url)
                webView.load(request)
                self.navigationController?.pushViewController(controller, animated: true)
                let barcode = UIBarButtonItem(title: "掃描Barcode", style: .done, target: self, action: #selector(self.barcodeButtonTapped))
                controller.navigationItem.rightBarButtonItem  = barcode
                break

            case 13:
                let url = URL.init(string: "https://apps.youthbio.com.tw/gps/#/sales")!
                let request = URLRequest.init(url: url)
                webView.load(request)
                let param = ["sales" : 0]
                NetworkManager.updateStoreBadges(parameters: param) { (result) in
                    print(result)
                    self.fetchBadges()
                }
                self.navigationController?.pushViewController(controller, animated: true)
                break
            case 17:
                QRCodeButtonTapped()
            case 18:
                let prescriptionsVC = PrescriptionsViewController()
                self.navigationController?.pushViewController(prescriptionsVC, animated: true)
                let param = ["prescription" : 0]
                NetworkManager.updateStoreBadges(parameters: param) { (result) in
                    print(result)
                    self.fetchBadges()
                }
                break
            case -1:
                let changePasswordVC = ChangePasswordViewController()
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
                break
            case -2:
                GlobalVariables.showAlertWithOptions(title: "登出", message: "確定要登出", confirmString: "登出", vc: self) {
                    print("已登出")
                    UserDefaults.standard.removeObject(forKey: "myToken")
                    NotificationCenter.default.post(name: Notification.Name("Logout"), object: nil)
                }
                break
            default:
                break
        }
    }
    
    @objc func presentMainMenu(notification: Notification) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc private func barcodeButtonTapped() {
        let barcodeScannerVC = BarcodeScannerViewController()
        barcodeScannerVC.modalPresentationStyle = .fullScreen
        barcodeScannerVC.query = BarcodeQuery.Price
        present(barcodeScannerVC, animated: true)
    }

    @objc private func searchBarcode(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let barcode = dict["barcode"] as? String{
                let url = URL.init(string: "https://apps.youthbio.com.tw/gps/#/commodity/barcode/" + barcode)!
                let request = URLRequest.init(url: url)
                webView.load(request)
                webView.reload()
            }
        }
    }

}


extension WKWebView {

    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookies(for domain: String? = nil, completion: @escaping ([String : Any])->())  {
        var cookieDict = [String : AnyObject]()
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}
