//
//  ModifieAlbumViewController.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 30/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//

import UIKit

class ModifieAlbumViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var dismissButton: UIButton!
  @IBOutlet weak var albumListPicker: UIPickerView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var newAlbumNameTF: UITextField!

  // MARK: - Properties
  let albumManagerInstance = AlbumManager()
  let alertControllerInstance = AlertController()
  var albumList: [String] = []
  var selectedAlbum = String()

  // MARK: - Methodes
  override func viewDidLoad() {
    super.viewDidLoad()
    setAlbumListPicker()
    hideKeyboardWhenTappedAround()
  }

  // MARK: - Action
  @IBAction func didTapDismissButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - This extension manage modifying album Name
extension ModifieAlbumViewController {
  // MARK: - Action
  @IBAction func didTapSaveButton(_ sender: UIButton) {
    checkMissingInfos()
  }
  // MARK: - Methodes
  private func checkMissingInfos() {
    if selectedAlbum == "" {
      let msg = "Veuillez choisir un album à modifier"
      alertControllerInstance.genericAlert(controller: self, msg: msg)
    } else if newAlbumNameTF.text == "" {
      let msg = "Veuillez donner un nouveau nom a l'album séléctionner"
      alertControllerInstance.genericAlert(controller: self, msg: msg)
    } else {
      modifieAlbumName()
    }
  }
  private func modifieAlbumName() {
    guard let newName = newAlbumNameTF.text else {return}
    albumManagerInstance.modifieAlbumName(controller: self, album: selectedAlbum, newName: newName)
  }
}

// MARK: - This extension manage Album list Picker
extension ModifieAlbumViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  // MARK: - Methodes
  func setAlbumListPicker() {
    albumList = albumManagerInstance.getListofAlbum()
    albumList.insert("", at: 0)
    albumListPicker.delegate = self
    albumListPicker.dataSource = self
  }
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return albumList.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return albumList[row]
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedAlbum = albumList[row] as String
  }
}
