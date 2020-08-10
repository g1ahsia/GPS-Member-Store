//
//  ImagesViewController.swift
//  GPS Member Store
//
//  Created by Allen Hsiao on 2020/7/30.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class ImagesViewController: UIViewController, UIScrollViewDelegate {
    var images = [UIImage]()
    var scrollImageViews = [UIImageView]()
    
//    let imageScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.isPagingEnabled = true
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.layer.borderWidth = 5
//        return scrollView
//    }()
    
    let theScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.layer.borderWidth = 5
//        scrollView.layer.borderColor = UIColor .red.cgColor
        return scrollView
    }()

    
    var close : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: " ic_fill_cross_grey"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

        view.addSubview(theScrollView)
        view.addSubview(close)
        images = [#imageLiteral(resourceName: "product-img"), #imageLiteral(resourceName: "001246"), #imageLiteral(resourceName: "item-1")]
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        theScrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        theScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        theScrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        theScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        var previousImageScrollView = UIScrollView()
        for i in 0..<images.count {

            let imageScrollView = UIScrollView()
            imageScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            theScrollView.addSubview(imageScrollView)

//            imageScrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            imageScrollView.topAnchor.constraint(equalTo: theScrollView.topAnchor).isActive = true
            imageScrollView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.width).isActive = true
            imageScrollView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.height).isActive = true

//            imageScrollView.rightAnchor.constraint(equalTo: theScrollView.rightAnchor).isActive = true
//            imageScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            imageScrollView.minimumZoomScale = 1.0
            imageScrollView.zoomScale = 6.0
            imageScrollView.delegate = self
            imageScrollView.layer.borderWidth = 5
            imageScrollView.layer.borderColor = UIColor .blue.cgColor
            imageScrollView.backgroundColor = .purple
//            imageScrollView.isScrollEnabled = false

            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = images[i]
//            imageView.layer.borderColor = UIColor .red.cgColor
//            imageView.layer.borderWidth = 5
            imageScrollView.addSubview(imageView)
//            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
//            imageView.frame = CGRect(x: xPosition, y: 0, width: imageScrollView.frame.width, height: imageScrollView.frame.height)
            if (i == 0) {
                imageScrollView.leftAnchor.constraint(equalTo: theScrollView.leftAnchor).isActive = true
            }
            else {
                imageScrollView.leftAnchor.constraint(equalTo: previousImageScrollView.rightAnchor).isActive = true
            }
            imageView.topAnchor.constraint(equalTo: imageScrollView.topAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: imageScrollView.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor).isActive = true
            imageView.contentMode = .scaleAspectFit
            previousImageScrollView = imageScrollView
            
            scrollImageViews.append(imageView)
        }
        theScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(images.count)
//        imageScrollView.delegate = self
        
        close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        close.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true


    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       
        return scrollImageViews[0]
    }


    @objc func rotated() {
        if UIDevice.current.orientation == .faceDown {
            // it's face down
            theScrollView.contentSize.width = view.safeAreaLayoutGuide.layoutFrame.size.height * CGFloat(images.count)
        }

        else if UIDevice.current.orientation.isLandscape {
//            let window = UIApplication.shared.keyWindow
            

            print("Landscape actual height \(view.safeAreaLayoutGuide.layoutFrame.size.height)")
            theScrollView.contentSize.width = view.safeAreaLayoutGuide.layoutFrame.size.width * CGFloat(images.count)

        } else {
            print("Portrait actual height \(view.safeAreaLayoutGuide.layoutFrame.size.height)")
            theScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(images.count)
        }
    }
    
    @objc private func closeButtonTapped(sender: UIButton!) {
        dismiss(animated: true) {
        }
    }


}
