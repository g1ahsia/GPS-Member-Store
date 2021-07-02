//
//  PrescriptionViewController.swift
//  GPS Consumer
//
//  Created by Allen Hsiao on 2021/6/10.
//

import Foundation
import UIKit

class PrescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var prescriptionId : Int?
    var prescription = Prescription.init(id: 0, patientId: 0, patientName: "", status: 0, createdDate: "", patientSerial: "", patientDateOfBirth: "", recipientName: "", recipientMobile: "", recipientHomePhone: "", imageUrls: [""])
    let imagePicker = UIImagePickerController()
    var spinner = UIActivityIndicatorView(style: .gray)
    var numCachedImages = Int()
    var attachedImages = [UIImage]()
    var attachmentImageViews = [UIImageView]()

    lazy var infoTableView : UITableView = {
        var tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FormCell.self, forCellReuseIdentifier: "form")
        tableView.backgroundColor = .clear
        return tableView
    }()
        
    var processed : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("處理完成", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.addTarget(self, action: #selector(processedButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.isHidden = true
        return button
    }()
    
    var contentScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        scrollView.backgroundColor = UIColor .clear
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
        cell.selectionStyle = .none
        switch indexPath.row {
            case 0:
                cell.field = "病患姓名："
                cell.placeholder = "請輸入完整姓名"
                cell.fieldType = FieldType.DisplayOnly
                cell.answer = prescription.patientName
                break
            case 1:
                cell.field = "病患身分證字號："
//                cell.placeholder = "請輸入身份證字號"
                cell.fieldType = FieldType.DisplayOnly
                cell.answer = prescription.patientSerial
                break
            case 2:
                cell.field = "病患生日："
//                cell.placeholder = "請輸入生日"
                cell.fieldType = FieldType.DisplayOnly
                cell.answer = prescription.patientDateOfBirth
                break
            case 3:
                cell.field = "領藥人姓名："
//                cell.placeholder = "請輸入完整姓名"
                cell.fieldType = FieldType.DisplayOnly
                cell.answer = prescription.recipientName
                break
            case 4:
                cell.field = "領藥人手機："
//                cell.placeholder = "請輸入電話"
                cell.fieldType = FieldType.DisplayOnly
                cell.answer = prescription.recipientMobile
                break
            case 5:
                cell.field = "領藥人市話："
//                cell.placeholder = "請輸入電話"
                cell.fieldType = FieldType.DisplayOnly
                cell.answer = prescription.recipientHomePhone
                break
            case 6:
                cell.field = "備註："
    //                cell.placeholder = "請輸入電話"
                cell.fieldType = FieldType.DisplayOnly
                cell.answer = prescription.comment
                break

            default:
                cell.field = ""
                break
        }
        return cell
    }
    
    private func setupLayout() {
        if let prescriptionId = prescriptionId {
            NetworkManager.fetchPrescription(id: prescriptionId) { prescription in
                self.prescription = prescription
                DispatchQueue.main.async {
                    
                    if (self.prescription.status == 1) {
//                        self.contentScrollView.topAnchor.constraint(equalTo: self.infoTableView.bottomAnchor, constant: 10).isActive = true
                    }
                    else {
                        self.processed.isHidden = false
//                        self.contentScrollView.topAnchor.constraint(equalTo: self.processed.bottomAnchor, constant: 10).isActive = true
                    }
                    self.loadImages(self.prescription.imageUrls ?? [""])
                    self.infoTableView.reloadData()
                }
            }
        }
        contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        contentScrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        contentScrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        infoTableView.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
        infoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        processed.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        processed.topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 20).isActive = true
        processed.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        processed.heightAnchor.constraint(equalToConstant: 44).isActive = true
                
        spinner.centerXAnchor.constraint(equalTo: processed.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: processed.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        title = "處方箋明細"
        view .addSubview(contentScrollView)
        contentScrollView .addSubview(infoTableView)
        contentScrollView .addSubview(processed)
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
        
    }
    
    @objc private func photoButtonTapped(sender: UIButton!) {
        let alert = UIAlertController(title: "選擇圖檔", message: "", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "拍照", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
            self.view.endEditing(true)
        }))

        alert.addAction(UIAlertAction(title: "圖庫", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
            self.view.endEditing(true)
        }))
        
        alert.addAction(UIAlertAction(title: MSG_TITLE_CANCEL, style: .cancel , handler:{ (UIAlertAction)in
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc private func processedButtonTapped(sender: UIButton!) {
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
        sender.isEnabled = false
        sender.alpha = 0.5

        NetworkManager.processedPrescription(id: prescription.id) { result in
            DispatchQueue.main.async {
                if (result["status"] as! Int == 1) {
                    self.navigationController?.popViewController(animated: true)
                }
                else if (result["status"] as! Int == -1) {
                    GlobalVariables.showAlert(title: MSG_TITLE_PROCESS_PRESCRIPTION, message: ERR_CONNECTING, vc: self)
                }
                else {
                    GlobalVariables.showAlert(title: MSG_TITLE_PROCESS_PRESCRIPTION, message: ERR_PROCESSING_PRESCRIPTION, vc: self)
                }
                self.processed.isEnabled = true
                self.processed.alpha = 1.0
                self.spinner.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    private func sendMessage() {
        
    }
    
    func loadImages(_ urlStrings: [String]) {
        print("loading images ")

        numCachedImages = prescription.imageUrls!.count
        attachedImages = []
        for urlString in urlStrings {
            
            let url = URL(string: urlString)!
            print("Sending a request " + urlString )

            let downloadTask:URLSessionDownloadTask =
                URLSession.shared.downloadTask(with: url, completionHandler: { [self]
                (location: URL?, response: URLResponse?, error: Error?) -> Void in
                    
                print("got image ")

                if let location = location {
                    if let data:Data = try? Data(contentsOf: location) {
                        var images = attachedImages
                        if let image:UIImage = UIImage(data: data) {
                            images.append(image)
                            attachedImages = images
                            
                        }
                        else {
                            print("CANNOT DOWNLOAD IMAGE \(location)")
                            images.append(#imageLiteral(resourceName: "img_holder"))
                            attachedImages = images

                        }
                        if (images.count == numCachedImages) {
                            DispatchQueue.main.async(execute: { () -> Void in
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                
                                self.setupImages()
                                
                            })
                        }

                    }
                }
            })
            downloadTask.resume()
        }

    }
    
    func setupImages() {
        if attachedImages.count > 0 {
            for imageView in attachmentImageViews {
                imageView.image = nil
                imageView.removeFromSuperview()
            }
            attachmentImageViews.removeAll()
            
            for attachedImage in attachedImages {
                let imageView = UIImageView(image: attachedImage)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
//                imageView.translatesAutoresizing`MaskIntoConstraints = false
                attachmentImageViews.append(imageView)

                let tapImageView = MyTapGestureRecognizer(target: self, action: #selector(handleTap))
                tapImageView.imageView = imageView
                imageView.addGestureRecognizer(tapImageView)
                contentScrollView .addSubview(imageView)
            }
            
            for index in 0..<attachedImages.count {
                if (index == 0) {
                    if (self.prescription.status == 1) {
                        attachmentImageViews[index].topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 20).isActive = true
                    }
                    else {
                        attachmentImageViews[index].topAnchor.constraint(equalTo: processed.bottomAnchor, constant: 20).isActive = true
                    }
                    attachmentImageViews[index].leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                    attachmentImageViews[index].widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                    attachmentImageViews[index].heightAnchor.constraint(equalToConstant: 200).isActive = true
                }
                else {
                    attachmentImageViews[index].topAnchor.constraint(equalTo: attachmentImageViews[index-1].bottomAnchor, constant: 20).isActive = true
                    attachmentImageViews[index].leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                    attachmentImageViews[index].widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                    attachmentImageViews[index].heightAnchor.constraint(equalToConstant: 200).isActive = true
                }
            }
            attachmentImageViews[attachmentImageViews.count - 1].bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -34).isActive = true
            
        }
        else {
        }

    }

    @objc func handleTap(gestureRecognizer: MyTapGestureRecognizer) {
        let imagesVC = ImagesViewController()
        imagesVC.attachedImages = self.attachedImages
        imagesVC.modalPresentationStyle = .overFullScreen
        if let imageView = gestureRecognizer.imageView {
            imagesVC.currentIndex = attachmentImageViews.firstIndex(of: imageView)!
            self.present(imagesVC, animated: true)
        }
    }

}
