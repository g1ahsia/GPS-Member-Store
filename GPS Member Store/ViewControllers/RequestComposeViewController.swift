//
//  RequestComposeViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/29.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class RequestComposeViewController: UIViewController, UITextViewDelegate {
        
    @IBOutlet weak var composeViewBottomConstraint: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    
    var scrollViewBottomConstraint: NSLayoutConstraint? // for keyboard hide and show
    
    var bottomConstraint: NSLayoutConstraint?
            
    var attachedImageViews = [UIImageView]()
    
    var imageTopConstraints = [NSLayoutConstraint]()
    
    var deleteButtons = [UIButton]()

    var selectedRow = 0
        
    var kbSize = CGSize(width: 0.0, height: 0.0)
    
    fileprivate var lineCollectionViewBottomConstraint1: NSLayoutConstraint?
    fileprivate var lineCollectionViewBottomConstraint2: NSLayoutConstraint?

    
    var cancel : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("取消", for: .normal)
        button.setTitleColor(ATLANTIS_GREEN, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    var header : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Medium", size: 34)
        textLabel.text = "新增調撥需求"
        textLabel.textColor = MYTLE
        return textLabel
    }()


    var send : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("送出", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        button.isEnabled = true
        return button
    }()
    
    lazy var headerTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FormCell.self, forCellReuseIdentifier: "form")
        tableView.backgroundColor = .clear
        return tableView
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

    var descView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textColor = .black
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.isScrollEnabled = false
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor .red.cgColor
        return textView
    }()
    
    var descPlaceholder : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.text = "描述..."
        textLabel.textColor = BLACKAlpha40
        return textLabel
    }()
    
    var attach : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: " ic_circle_add"), for: .normal)
        button.addTarget(self, action: #selector(attachButtonTapped), for: .touchUpInside)
        return button
    }()
        
    var blackCover : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    lazy var typePickerView : UIPickerView = {
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.alpha = 0
        picker.delegate = self
        picker.setValue(MYTLE, forKeyPath: "textColor")
        return picker
    }()

    lazy var areaPickerView : UIPickerView = {
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.alpha = 0
        picker.delegate = self
        picker.setValue(MYTLE, forKeyPath: "textColor")
        return picker
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        view.backgroundColor = UIColor .white
        view.addSubview(cancel)
        view.addSubview(header)
        view.addSubview(send)
        headerTableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(attach)
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(headerTableView)
        contentScrollView .addSubview(descView)
        contentScrollView .addSubview(descPlaceholder)
        view.addSubview(blackCover)
        view.addSubview(typePickerView)
        view.addSubview(areaPickerView)
        descView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blackCover.addGestureRecognizer(tap)
        self.setupLayout()
        
        hideKeyboardWhenTappedOnView()
    }
    
    @objc private func cancelButtonTapped(sender: UIButton!) {
        self.dismiss(animated: true) {
        }
    }
    
    @objc private func attachButtonTapped(sender: UIButton!) {
        self.imagePicker.sourceType = .savedPhotosAlbum
        self.imagePicker.delegate = self
        self.present(self.imagePicker, animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    @objc private func lineButtonTapped(sender: UIButton!) {
        lineCollectionViewBottomConstraint1?.isActive = false
        lineCollectionViewBottomConstraint2?.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        self.view.endEditing(true)
    }
    

    @objc private func sendButtonTapped(sender: UIButton!) {
        print("sending message")
    }
    
//    @objc private func typeSelectionButtonTapped(sender: UIButton!) {
//        UIView .animate(withDuration: 0.3) {
//            self.blackCover.alpha = 0.5
//            self.pickerView.alpha = 1
//
//        }
//        typeSelection.setTitle(MESSAGE_SUBJECTS[selectedRow], for: .normal)
//    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        UIView .animate(withDuration: 0.3) {
            self.blackCover.alpha = 0
            self.typePickerView.alpha = 0
            self.areaPickerView.alpha = 0
        }
    }

    
    private func setupLayout() {
        attach.topAnchor.constraint(equalTo: view.topAnchor, constant: 129).isActive = true
        attach.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        contentScrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        contentScrollView.topAnchor.constraint(equalTo: attach.bottomAnchor, constant: 10).isActive = true
        contentScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        headerTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        headerTableView.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
        headerTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        headerTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        scrollViewBottomConstraint = contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        scrollViewBottomConstraint?.isActive = true
        
        descView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        descView.topAnchor.constraint(equalTo: headerTableView.bottomAnchor, constant: 10).isActive = true
        descView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        descView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        bottomConstraint = descView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -34)
        bottomConstraint?.isActive = true

        descPlaceholder.leftAnchor.constraint(equalTo: contentScrollView.leftAnchor, constant: 16).isActive = true
        descPlaceholder.topAnchor.constraint(equalTo: headerTableView.bottomAnchor, constant: 10).isActive = true
        descPlaceholder.widthAnchor.constraint(equalToConstant: 100).isActive = true
        descPlaceholder.heightAnchor.constraint(equalToConstant: 20).isActive = true

        cancel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        cancel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        header.widthAnchor.constraint(equalToConstant: 233).isActive = true
        header.heightAnchor.constraint(equalToConstant: 41).isActive = true

        send.topAnchor.constraint(equalTo: view.topAnchor, constant: 56).isActive = true
        send.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        send.widthAnchor.constraint(equalToConstant: 88).isActive = true
        send.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        blackCover.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        blackCover.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        blackCover.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        blackCover.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        typePickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        typePickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        typePickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                
        areaPickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        areaPickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        areaPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    func textViewDidChange(_ textView: UITextView) {
        descPlaceholder.isHidden = !textView.text.isEmpty
        if (textView.text.isEmpty) {
            send.alpha = 0.5
            send.isEnabled = false
        }
        else {
            send.alpha = 1.0
            send.isEnabled = true
        }
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { // Change `0.05` to the desired number of seconds.
            self.scrollToCursor()
        }
    }
    
    private func scrollToCursor() {
        // TextView
        let textViewOrigin = self.view.convert(descView.frame, from: self.view).origin
        
        // Cursor
        let textViewCursor = descView.caretRect(for: descView.selectedTextRange!.start).origin
        let cursorPoint = CGPoint(x: textViewCursor.x + textViewOrigin.x, y: textViewCursor.y + contentScrollView.frame.origin.y - contentScrollView.contentOffset.y + 200 + 25)

        let keyboardTop = self.view.frame.size.height - kbSize.height
        print("keyboardTop ", keyboardTop)
        
        print("cursor position y ", cursorPoint.y)
        
        if (view.safeAreaLayoutGuide.layoutFrame.origin.y + cursorPoint.y > keyboardTop &&
            cursorPoint.y != .infinity) {
            contentScrollView.contentOffset = CGPoint(x: 0, y: (cursorPoint.y - (self.view.frame.size.height - kbSize.height)) + contentScrollView.contentOffset.y)
        }

    }

    @objc func keyboardWillShow(notification:NSNotification){

        print("keyboardWillShow")

        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        kbSize = keyboardFrame.size
        
        self.scrollViewBottomConstraint?.isActive = false
        self.scrollViewBottomConstraint = contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardFrame.size.height)
        self.scrollViewBottomConstraint?.isActive = true
    }

    @objc func keyboardWillHide(notification:NSNotification){
        print("keyboardWillHide")

        self.scrollViewBottomConstraint?.isActive = false
        self.scrollViewBottomConstraint = contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.scrollViewBottomConstraint?.isActive = true

    }
    
    @objc func addImageToView(image:UIImage){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = image
        
        
        let delete = UIButton()
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.setImage(#imageLiteral(resourceName: " ic_fill_cross_grey"), for: .normal)
        delete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        contentScrollView .addSubview(imageView)
        imageView .addSubview(delete)
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: image.size.height/image.size.width).isActive = true
        
        var topConstraint: NSLayoutConstraint?
        
        if (attachedImageViews.count == 0) {
            topConstraint = imageView.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 30)
        }
        else {
            topConstraint = imageView.topAnchor.constraint(equalTo: attachedImageViews[attachedImageViews.count - 1].bottomAnchor, constant: 30)
        }
        topConstraint?.isActive = true
        
        delete.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        delete.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        delete.widthAnchor.constraint(equalToConstant: 30).isActive = true
        delete.heightAnchor.constraint(equalToConstant: 30).isActive = true

        bottomConstraint?.isActive = false
        bottomConstraint = imageView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -34)
        bottomConstraint?.isActive = true
        
        deleteButtons.append(delete)
        attachedImageViews.append(imageView)
        imageTopConstraints.append(topConstraint!)

    }
    
    @objc private func deleteButtonTapped(sender: UIButton!) {
        let deletedIndex = deleteButtons.firstIndex(of: sender)
        let imageView = attachedImageViews[deletedIndex!]
        imageView.removeFromSuperview()
        if (deletedIndex == deleteButtons.count - 1) {
        }
        else if (deletedIndex == 0) {
            let imageView = attachedImageViews[1]
            var topConstraint = imageTopConstraints[1]
            topConstraint.isActive = false
            topConstraint = imageView.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 30)
            topConstraint.isActive = true
        }
        else {
            let previousImageView = attachedImageViews[deletedIndex! - 1]
            let nextImageView = attachedImageViews[deletedIndex! + 1]
            var topConstraint = imageTopConstraints[deletedIndex! + 1]
            topConstraint.isActive = false
            topConstraint = nextImageView.topAnchor.constraint(equalTo: previousImageView.bottomAnchor, constant: 30)
            topConstraint.isActive = true
        }
        deleteButtons.remove(at: deletedIndex!)
        attachedImageViews.remove(at: deletedIndex!)
        imageTopConstraints.remove(at: deletedIndex!)
    }

}

extension RequestComposeViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == typePickerView) {
            if component == 0 {
                return REQUEST_SUBJECTS.count
            }
            return 0
        }
        else {
            if component == 0 {
                return AREA_SUBJECTS.count
            }
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == typePickerView) {
            if component == 0 {
                return REQUEST_SUBJECTS[row]
            }
            return ""
        }
        else {
            if component == 0 {
                return AREA_SUBJECTS[row]
            }
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == typePickerView) {
            let cell0 = headerTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
            cell0.answer = REQUEST_SUBJECTS[row]
            selectedRow = row
            cell0.layoutSubviews()
        }
        else {
            let cell1 = headerTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
            cell1.answer = AREA_SUBJECTS[row]
            selectedRow = row
            cell1.layoutSubviews()
        }
    }

}

extension RequestComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print(info)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImageToView(image: pickedImage)
        }

        
        picker.dismiss(animated: true) {
        }

        
    }
}

extension RequestComposeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
        cell.selectionStyle = .none
        switch indexPath.row {
            case 0:
                cell.field = "調撥類型："
                cell.placeholder = "請選擇"
                cell.fieldType = FieldType.Selection
            case 1:
                cell.field = "適用區域："
                cell.placeholder = "請選擇"
                cell.fieldType = FieldType.Selection
            case 2:
                cell.field = "商品名稱："
                cell.fieldType = FieldType.Text
            case 3:
                cell.field = "商品價格："
                cell.fieldType = FieldType.Number
            case 4:
                cell.field = "商品數量："
                cell.fieldType = FieldType.Number
            default:
                cell.field = ""
        }
        cell.layoutSubviews()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                self.view.endEditing(true)
                UIView .animate(withDuration: 0.3) {
                    self.blackCover.alpha = 0.5
                    self.typePickerView.alpha = 1
                    self.areaPickerView.alpha = 0
                }
                let cell0 = headerTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
                cell0.answer = REQUEST_SUBJECTS[selectedRow]
                cell0.layoutSubviews()
                break
            case 1:
                self.view.endEditing(true)
                UIView .animate(withDuration: 0.3) {
                    self.blackCover.alpha = 0.5
                    self.typePickerView.alpha = 0
                    self.areaPickerView.alpha = 1
                }
                let cell1 = headerTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
                cell1.answer = AREA_SUBJECTS[selectedRow]
                cell1.layoutSubviews()
                break
            case 2:
                break
            case 3:
                break
            case 4:
                break
            default:
                break
            }
    }
}
