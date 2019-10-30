//
//  AlertController.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 28/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//

import UIKit

class AlertController {

  // MARK: - This is a generic alert
  func genericAlert(controller: UIViewController, msg: String) {
    let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "D'accord", style: .default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
  }

  // MARK: - This is a generic dismiss alert
  func genericDismissAlert(controller: UIViewController, msg: String) {
    let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "D'accord", style: .default, handler: { (_) in
      controller.dismiss(animated: true, completion: nil)
    }))
    controller.present(alert, animated: true, completion: nil)
  }
}
