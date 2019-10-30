//
//  CreatAlbumViewController.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 28/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//

import UIKit

class CreatAlbumViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var dismissButton: UIButton!
  @IBOutlet weak var albumNameTF: UITextField!
  @IBOutlet weak var infosLB: UILabel!
  @IBOutlet weak var creatAlbumButton: UIButton!

  // MARK: - Properties
  let alertControllerInstance = AlertController()
  let albumManagerInstance = AlbumManager()

  // MARK: - Methodes
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    setLabel()
  }
  private func setLabel() {
    infosLB.text = "Pour créer un album, veuillez lui donner un nom et appuyer sur le bouton."
  }

  // MARK: - Action
  @IBAction func didTapDismissButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

extension CreatAlbumViewController {
  // MARK: - Action
  @IBAction func didTapCreatAlbumButton(_ sender: UIButton) {
    checkEmptyField()
  }
  // MARK: - Methodes
  private func checkEmptyField() {
    if albumNameTF.text == "" {
      let msg = "Veuillez donner un nom à votre album"
      alertControllerInstance.genericAlert(controller: self, msg: msg)
    } else {
      creatNewAlbum()
    }
  }
  private func creatNewAlbum() {
    guard let albumName = albumNameTF.text else {return}
    albumManagerInstance.creatCustomAlbum(controller: self, name: albumName)
  }

}
