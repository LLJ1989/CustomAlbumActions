//
//  MediaManage.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 29/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//  swiftlint:disable line_length private_over_fileprivate

import Foundation
import UIKit
import Photos

class MediaManager: NSObject {

  // MARK: Properties
  var imagePickedBlock: ((UIImage) -> Void)?
  var videoPickedBlock: ((NSURL) -> Void)?
  var controller: UIViewController!

  // MARK: - Enumeration
  enum AttachmentType: String {
    case camera, photoLibrary
  }

  // MARK: - This methode show to user an action sheet with camera and photolibrary choice
  func addMedia(currentVC: UIViewController) {
    controller = currentVC
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Appareil Photo", style: .default, handler: { (_) in
      self.askAuthorization(type: .camera)
    }))
    actionSheet.addAction(UIAlertAction(title: "Pellicule", style: .default, handler: { (_) in
      self.askAuthorization(type: .photoLibrary)
    }))
    actionSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
    currentVC.present(actionSheet, animated: true, completion: nil)
  }
  // MARK: - This methode askUserPermission to ac cess to Camera and Photo Library
  func askAuthorization(type: AttachmentType) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
      if type == .camera { print("camera") ; camera() }
      if type == .photoLibrary { print("Photo Library") ; photoLibrary() }
    case .denied:
      print("Permission denied") ; addAlertForSettings(type: type)
    case .notDetermined:
      print("Not determined")
      PHPhotoLibrary.requestAuthorization { (status) in
        if status == .authorized {
          if type == .camera { self.camera() }
          if type == .photoLibrary { self.photoLibrary() }
        } else {
          print("Manually restricted") ; self.addAlertForSettings(type: type)
        }
      }
    case .restricted: print("restricted") ; addAlertForSettings(type: type)
    default: break
    }
  }
  // MARK: - This methode allert user about camera and photoLibrary authorization
  func addAlertForSettings(type: AttachmentType) {
    var alertTitle: String = ""
    if type == .camera { alertTitle = "Vous n'avez pas authorisé l'application d'utiliser la caméra. Pour l'autoriser, allez dans les paramètres puis revenez ici."}
    if type == .photoLibrary { alertTitle = "Vous n'avez pas authorisé l'application à accéder à la pélicule. Pour l'autoriser, allez dans les paramètres puis revenez ici."}
    let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Paramètres", style: .destructive, handler: { (_) in
      let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
      if let url = settingsUrl { UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)}
    }))
    alert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
  }
  // MARK: - This methode gives access to photo library
  func photoLibrary() {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let picker = UIImagePickerController()
      picker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
      picker.sourceType = .photoLibrary ; picker.allowsEditing = true
      picker.mediaTypes = ["public.image", "public.movie"]
      controller.present(picker, animated: true, completion: nil)
    }
  }
  // MARK: - This methode gives access to camera
  func camera() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let picker = UIImagePickerController()
      picker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
      picker.sourceType = .camera ; picker.allowsEditing = true
      picker.showsCameraControls = true ; picker.mediaTypes = ["public.image", "public.movie"]
      picker.videoQuality = .typeHigh
      controller.present(picker, animated: true, completion: nil)
    }
  }
}
// MARK: - This extension is needed since Swift 4.2.
extension MediaManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  // MARK: - Methodes
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    controller.dismiss(animated: true, completion: nil)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { self.imagePickedBlock?(image) }
    if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL { _ = NSData(contentsOf: videoUrl as URL)! ; compressWithSessionStatusFunc(videoUrl) }
    controller.dismiss(animated: true, completion: nil)
  }
  fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
    let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
    compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
      guard let session = exportSession else { return }
      switch session.status {
      case .unknown: break
      case .waiting: break
      case .exporting: break
      case .completed:
        guard NSData(contentsOf: compressedURL) != nil else { return }
        DispatchQueue.main.async { self.videoPickedBlock?(compressedURL as NSURL) }
      case .failed: break
      case .cancelled: break
      default: break
      }
    }
  }
  func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
    let urlAsset = AVURLAsset(url: inputURL, options: nil)
    guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else { handler(nil) ; return }
    exportSession.outputURL = outputURL
    exportSession.outputFileType = AVFileType.mov
    exportSession.shouldOptimizeForNetworkUse = true
    exportSession.exportAsynchronously { () -> Void in
      handler(exportSession)
    }
  }
}

// MARK: - Helper methodes neede since Swift 4.2.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
  return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
  return input.rawValue
}
