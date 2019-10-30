//
//  RemoveAlbumViewController.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 28/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//

import UIKit

class RemoveAlbumViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var dismissButton: UIButton!
  @IBOutlet weak var infosLB: UILabel!
  @IBOutlet weak var albumListPV: UIPickerView!
  @IBOutlet weak var removeAlbumButton: UIButton!

  // MARK: - Properties
  let alertControllerInstance = AlertController()
  let albumManagerInstance = AlbumManager()
  var albumList: [String] = []
  var selectedAlbum = String()
  // MARK: - Methodes
  override func viewDidLoad() {
    super.viewDidLoad()
    setAlbumListPicker()
    setLabel()
  }
  private func setLabel() {
    infosLB.text = """
    Pour supprimer un album, veuillez le sélectionner dans la liste ci-dessous
    Appuyez sur le bouton 'Supprimer l'album'
    """
  }
  // MARK: - Action
  @IBAction func didTapDismissButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - This extension manage removing album
extension RemoveAlbumViewController {
  // MARK: - Action
  @IBAction func didTapRemoveAlbumButton(_ sender: UIButton) {
    checkEmptyField()
  }
  // MARK: - Methodes
  private func checkEmptyField() {
    if selectedAlbum == "" {
      let msg = "Veuillez selectionner un album a supprimer"
      alertControllerInstance.genericAlert(controller: self, msg: msg)
    } else {
      albumManagerInstance.removeSpecificAlbum(controller: self, name: selectedAlbum)
    }
  }
}

// MARK: - This extension set albumList picker
extension RemoveAlbumViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  // MARK: - Methodes
  func setAlbumListPicker() {
    albumList = albumManagerInstance.getListofAlbum()
    albumList.insert("", at: 0)
    albumListPV.delegate = self
    albumListPV.dataSource = self
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
