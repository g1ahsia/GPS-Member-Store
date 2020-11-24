//
//  QRCodeViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/31.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class QRCodeViewController: UIViewController, UITextViewDelegate {
    var selectedPoint = 1
    var QRCodeBackground : UIView = {
        var view = UIView()
        view.backgroundColor = MYTLE
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "1_sHmqYIYMV_C3TUhucHrT4w")
        return imageView
    }()
    
    var descView : UITextView = {
        var textView = UITextView()
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textColor = .black
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.clipsToBounds = true;
        textView.text = "・此行動條碼限用1次。\n・條碼掃描後，請重新點選欲發送的點數來產生新的條碼。"
        return textView
    }()
    
    var send : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("發送點數", for: .normal)
        button.setTitleColor(MYTLE, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()

    
    var refresh : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: " ic_refresh_grey"), for: .normal)
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        return button
    }()

    var point : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+1點", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(pointButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var pointPickerView : UIPickerView = {
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = SNOW
        picker.alpha = 0
        picker.delegate = self
        picker.clipsToBounds = false
        picker.setValue(MYTLE, forKeyPath: "textColor")
        return picker
    }()

    var blackCover : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    var toolbar : UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = ATLANTIS_GREEN
        toolBar.sizeToFit()
        toolBar.alpha = 0
        toolBar.barTintColor = SNOW
        let doneButton = UIBarButtonItem(title: "確定", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "點數發送"
        view.backgroundColor = SNOW
        view.addSubview(QRCodeBackground)
        QRCodeBackground.addSubview(mainImageView)
        view.addSubview(descView)
        view.addSubview(point)
        view.addSubview(send)
        view.addSubview(refresh)
        view.addSubview(blackCover)
        view.addSubview(pointPickerView)
        view.addSubview(toolbar)
        setupLayout()
    }
    
    private func setupLayout() {
        QRCodeBackground.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        QRCodeBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        QRCodeBackground.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        QRCodeBackground.heightAnchor.constraint(equalTo: QRCodeBackground.widthAnchor).isActive = true
        
        mainImageView.leftAnchor.constraint(equalTo: QRCodeBackground.leftAnchor, constant: 45).isActive = true
        mainImageView.topAnchor.constraint(equalTo: QRCodeBackground.topAnchor, constant: 45).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: QRCodeBackground.rightAnchor, constant: -45).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: QRCodeBackground.bottomAnchor, constant: -45).isActive = true

        descView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        descView.topAnchor.constraint(equalTo: QRCodeBackground.bottomAnchor, constant: 20).isActive = true
        descView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        descView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        point.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        point.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 20).isActive = true
        point.widthAnchor.constraint(equalToConstant: 108).isActive = true
        point.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        refresh.rightAnchor.constraint(equalTo: point.leftAnchor, constant: -20).isActive = true
        refresh.widthAnchor.constraint(equalToConstant: 40).isActive = true
        refresh.heightAnchor.constraint(equalToConstant: 40).isActive = true
        refresh.centerYAnchor.constraint(equalTo: point.centerYAnchor).isActive = true
        
        send.leftAnchor.constraint(equalTo: point.rightAnchor, constant: 20).isActive = true
        send.widthAnchor.constraint(equalToConstant: 80).isActive = true
        send.heightAnchor.constraint(equalToConstant: 40).isActive = true
        send.centerYAnchor.constraint(equalTo: point.centerYAnchor).isActive = true

        pointPickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pointPickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pointPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        toolbar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        toolbar.topAnchor.constraint(equalTo: pointPickerView.topAnchor, constant: -44).isActive = true
        toolbar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true

        blackCover.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        blackCover.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        blackCover.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        blackCover.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    @objc private func refreshButtonTapped(sender: UIButton!) {
        point.setTitle("+1點", for: .normal)
        createQRCode()
    }
    
    @objc private func sendButtonTapped(sender: UIButton!) {
        let consumerSearchVC = ConsumerSearchViewController()
        consumerSearchVC.purpose = ConsumerSearchPurpose.SendPoints
        consumerSearchVC.points = selectedPoint
        self.navigationController?.pushViewController(consumerSearchVC, animated: true)
    }
    
    @objc private func pointButtonTapped(sender: UIButton!) {
        UIView .animate(withDuration: 0.3) {
            self.toolbar.alpha = 1
            self.blackCover.alpha = 0.5
            self.pointPickerView.alpha = 1
        }
    }

    @objc private func doneButtonTapped() {
        UIView .animate(withDuration: 0.3) {
            self.toolbar.alpha = 0
            self.blackCover.alpha = 0
            self.pointPickerView.alpha = 0
        }
        point.setTitle("+\(selectedPoint)點", for: .normal)
        createQRCode()
    }

    @objc private func cancelButtonTapped() {
        UIView .animate(withDuration: 0.3) {
            self.toolbar.alpha = 0
            self.blackCover.alpha = 0
            self.pointPickerView.alpha = 0
        }
        
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        UIView .animate(withDuration: 0.3) {
            self.toolbar.alpha = 0
            self.blackCover.alpha = 0
            self.pointPickerView.alpha = 0
        }
    }
    
    private func createQRCode() {
        NetworkManager.createQRCode(points: selectedPoint) { (qrCode) in
            DispatchQueue.main.async {
                let imageData = qrCode.image
                if let decodedData = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters) {
                    let image = UIImage(data: decodedData)
                    self.mainImageView.image = image
                }
            }
        }
    }

}

extension QRCodeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 10
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "+\(row + 1)點"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPoint = row + 1

    }

}
