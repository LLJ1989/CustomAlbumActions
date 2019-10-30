//
//  HomeViewController.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 28/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  // MARK: - Methodes
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Actions
  @IBAction func didTapCreatAlbumButton(_ sender: UIButton) {
    performSegue(withIdentifier: "segueToCreatAlbumVC", sender: sender)
  }
  @IBAction func didTapRemoveAlbumButton(_ sender: UIButton) {
    performSegue(withIdentifier: "segueToRemoveAlbumVC", sender: sender)
  }
  @IBAction func didTapAddMediasButton(_ sender: UIButton) {
    performSegue(withIdentifier: "segueToAddMediasVC", sender: sender)
  }
  @IBAction func didTapRemoveMediasVC(_ sender: UIButton) {
    performSegue(withIdentifier: "segueToRemoveMediasVC", sender: sender)
  }
  @IBAction func didTapModifieAlbumButton(_ sender: UIButton) {
    performSegue(withIdentifier: "segueToModifieAlbumVC", sender: sender)
  }
}
