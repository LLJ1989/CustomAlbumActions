//
//  AddMediasViewController.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 29/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//

import UIKit
import Photos

class AddMediasViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var videoContainer: UIView!
  @IBOutlet weak var photoContainer: UIImageView!
  @IBOutlet weak var addMediaButton: UIButton!
  @IBOutlet weak var infosLB: UILabel!
  @IBOutlet weak var albumPicker: UIPickerView!
  @IBOutlet weak var saveMediaButton: UIButton!

  // MARK: - Properties
  let albumManagerInstance = AlbumManager()
  let alertControllerInstance = AlertController()
  let mediaManagerInstance = MediaManager()
  var albumList: [String] = []
  var selectedAlbum = String()
  var isVideo = Bool()
  var video: URL!
  var isPhoto = Bool()
  var image: UIImage!
  var avPlayerLayer: AVPlayerLayer!
  var avPlayerToSave = AVPlayer()
  let avPlayer = AVPlayer()
  var presentMedia = false

  // MARK: - Methodes
  override func viewDidLoad() {
    super.viewDidLoad()
    setAlbumListPicker()
    setLabel()
  }
  private func setLabel() {
    infosLB.text = """
    Veuillez séléctionner un média en cliquant sur le carré blanc.
    Séléctionnez l'album dans lequel vous voulez l'enregister.
    Appuyer sur le bouton 'Enregistrer le média'
    """
  }

  // MARK: - Action
  @IBAction func didTapDismissButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - This extension manage saving media in selected album
extension AddMediasViewController {
  // MARK: - Action
  @IBAction func didTapSaveMediaButton(_ sender: UIButton) {
    checkMissingInfos()
  }
  // MARK: - Methodes
  private func checkMissingInfos() {
    if presentMedia == false {
      let msg = "Vous devez ajouter une photo ou une vidéo à enregistrer."
      alertControllerInstance.genericAlert(controller: self, msg: msg)
    } else if selectedAlbum == "" {
      let msg = "Vous devez séléctionner un album dans lequel enregistrer votre média."
      alertControllerInstance.genericAlert(controller: self, msg: msg)
    } else {
      saveMedia()
    }
  }
  private func saveMedia() {
    if isPhoto == true && isVideo == false {
      albumManagerInstance.saveImageToSpecificAlbum(controller: self, image: image, album: selectedAlbum)
    } else if isPhoto == false && isVideo == true {
      albumManagerInstance.saveVideoToSpecificAlbum(controller: self, video: video, album: selectedAlbum)
    }
  }
}

// MARK: - This extension manage adding media
extension AddMediasViewController {
  // MARK: - Action
  @IBAction func didTapAddMediaButton(_ sender: UIButton) {
    addMedia()
  }
  // MARK: - Methodes
  private func addMedia() {
    mediaManagerInstance.addMedia(currentVC: self)
    mediaManagerInstance.imagePickedBlock = { (image) in
      self.image = image as UIImage
      self.isPhoto = true ; self.isVideo = false
      DispatchQueue.main.async {
        self.checkMediaType()
      }
    }
    mediaManagerInstance.videoPickedBlock = { (video) in
      self.video = video as URL
      self.isPhoto = false ; self.isVideo = true
      DispatchQueue.main.async {
        self.checkMediaType()
      }
    }
  }
  private func checkMediaType() {
    if isPhoto == true && isVideo == false {
      videoContainer.isHidden = true ; photoContainer.image = image
      photoContainer.isHidden = false ; presentMedia = true
    } else if isPhoto == false && isVideo == true {
      videoContainer.isHidden = false
      photoContainer.isHidden = true
      playVideo()
      presentMedia = true
    }
  }
  private func playVideo() {
    avPlayerLayer = AVPlayerLayer(player: avPlayer)
    avPlayerLayer.frame = videoContainer.bounds
    avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    videoContainer.layer.insertSublayer(avPlayerLayer, at: 0)
    view.layoutIfNeeded()
    let playerItem = AVPlayerItem(url: video as URL)
    avPlayer.replaceCurrentItem(with: playerItem)
    avPlayerToSave = avPlayer
    avPlayerToSave.play()
  }
}

// MARK: - This extension manage setting Album Picker
extension AddMediasViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  // MARK: - Methodes
  func setAlbumListPicker() {
    albumList = albumManagerInstance.getListofAlbum()
    albumList.insert("", at: 0)
    albumPicker.delegate = self
    albumPicker.dataSource = self
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
