//
//  Extensions.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 28/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//  

import UIKit
import Photos

extension UIViewController {
  // MARK: - This extension hides keyboard when tappedAround
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.disKeybd))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  @objc func disKeybd() { view.endEditing(true) }
}

extension UIImage {
  // MARK: - This extension resize UIImage. It's used to produice thumbnail
  func reduiceImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    var newSize: CGSize
    if widthRatio > heightRatio {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
}
