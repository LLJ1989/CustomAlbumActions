//
//  AlbumManager.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 28/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//  swiftlint:disable line_length multiple_closures_with_trailing_closure

import UIKit
import Photos

class AlbumManager {

  // MARK: - Properties
  let alertControllerInstance = AlertController()
  var assetCollection: PHAssetCollection!
  var photoAssets = PHFetchResult<AnyObject>()

  // MARK: - This methode modifie Album name
  func modifieAlbumName(controller: UIViewController, album: String, newName: String) {
    guard let album = getSpecificAlbum(name: album) else {return}
    PHPhotoLibrary.shared().performChanges({
      let albumRequest = PHAssetCollectionChangeRequest(for: album)
      albumRequest?.title = newName
    }) { (success, error) in
        if success {
          DispatchQueue.main.async {
            let msg = "L'album a bien été renommé => \(album)"
            self.alertControllerInstance.genericDismissAlert(controller: controller, msg: msg)
          }
        }
        guard let error = error else {return}
        print("Failure: Saving video failed, error => \(error.localizedDescription)")
      }
  }

  // MARK: - This methode remove phasset (image or video) to a specific album
  func removeMedia(controller: UIViewController, asset: PHAsset) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
    }) { (success, error) in
      if success {
        DispatchQueue.main.async {
          let msg = "Le media a bien été supprimé dans l'album"
          self.alertControllerInstance.genericDismissAlert(controller: controller, msg: msg)
        }
      }
      guard let error = error else {return}
      print("Failure: Saving video failed, error => \(error.localizedDescription)")
    }
  }

  // MARK: - These methodes are used to save photo / video in a specifi album
  // MARK: - This methode save image in a specific album
  func saveImageToSpecificAlbum(controller: UIViewController, image: UIImage, album: String) {
    guard let alb = getSpecificAlbum(name: album) else {return}
    PHPhotoLibrary.shared().performChanges({
      let requestImage = PHAssetChangeRequest.creationRequestForAsset(from: image)
      let requestAlbum = PHAssetCollectionChangeRequest(for: alb)
      guard let specificRequest = requestAlbum, let placeholder = requestImage.placeholderForCreatedAsset else {return}
      let arraySpecificRequest: NSArray = [placeholder]
      specificRequest.addAssets(arraySpecificRequest)
    }) { (success, error) in
      if success {
        DispatchQueue.main.async {
          let msg = "L'image a bien été enregistrée dans l'album => \(album)"
          self.alertControllerInstance.genericAlert(controller: controller, msg: msg)
        }
      }
      guard let error = error else {return}
      print("Failure: Saving video failed, error => \(error.localizedDescription)")
    }
  }
  // MARK: - This methode save video in a specific album
  func saveVideoToSpecificAlbum(controller: UIViewController, video: URL, album: String) {
    guard let alb = getSpecificAlbum(name: album) else {return}
    PHPhotoLibrary.shared().performChanges({
      let requestVideo = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: video)
      let requestAlbum = PHAssetCollectionChangeRequest(for: alb)
      guard let specificRequest = requestAlbum, let placeholder = requestVideo?.placeholderForCreatedAsset else {return}
      let arraySpecificRequest: NSArray = [placeholder]
      specificRequest.addAssets(arraySpecificRequest)
    }) { (success, error) in
      if success {
        DispatchQueue.main.async {
          let msg = "La video a bien été enregistrée dans l'album => \(album)"
          self.alertControllerInstance.genericAlert(controller: controller, msg: msg)
        }
      }
      guard let error = error else {return}
      print("Failure: Saving video failed, error => \(error.localizedDescription)")
    }
  }

  // MARK: - These next methodes are used to delete specific custom album
  // MARK: - This methode list all album
  func getListofAlbum() -> [String] {
    var albumNameArray: [String] = []
    let customsAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
    print(customsAlbum)
    customsAlbum.enumerateObjects { (object, _, _) in
      if object is PHAssetCollection {
        albumNameArray.append(object.localizedTitle!)
      }
    }
    return albumNameArray
  }
  // MARK: - This methode get specific album
  func getSpecificAlbum(name: String) -> PHAssetCollection? {
    let fetchPredicate = PHFetchOptions()
    fetchPredicate.predicate = NSPredicate(format: "title == '" + name + "'")
    let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchPredicate)
    fetchResult.firstObject == nil ? print("Failure: fetch album") : print("Success: fetch album")
    return fetchResult.firstObject
  }
  // MARK: - This methode remove album
  func removeSpecificAlbum(controller: UIViewController, name: String) {
    PHPhotoLibrary.requestAuthorization { (status) in
      switch status {
      case .authorized:
        PHPhotoLibrary.shared().performChanges({
          let album = [self.getSpecificAlbum(name: name)] as NSFastEnumeration
          PHAssetCollectionChangeRequest.deleteAssetCollections(album)
        }) { (success, error) in
          if success {
            DispatchQueue.main.async {
              let msg = "L'album : \(name) a bien été supprimé"
              self.alertControllerInstance.genericDismissAlert(controller: controller, msg: msg)
            }
          }
          guard let error = error else {return}
          print("Failure: removing album failed, error => \(error.localizedDescription)")
        }
      default:
        print(" ")
      }
    }
  }

  // MARK: - These next methodes are used to creat new custom album
  // MARK: - This methode check if Album dosen't exist yet
  func checkIfExistingAlbum(name: String) -> Bool {
    var isExist: Bool!
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", name)
    let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
    isExist =  collection.firstObject != nil ? true : false
    return isExist
  }
  // MARK: - This methode request user before creating custom Album
  func creatCustomAlbum(controller: UIViewController, name: String) {
    let isExist = checkIfExistingAlbum(name: name)
    switch isExist {
    case false:
      PHPhotoLibrary.requestAuthorization { (status) in
        switch status {
        case .authorized:
          PHPhotoLibrary.shared().performChanges({
              PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
          }) { success, error in
              if success {
                DispatchQueue.main.async {
                  let msg = "L'album : \(name) a bien été créé !"
                  self.alertControllerInstance.genericDismissAlert(controller: controller, msg: msg)
                }
              } else {
                print("Failure: error => \(String(describing: error))")
              }
          }
        default: print("Failure: authorization of creating custom album.")
        }
      }
    case true:
      let msg = "Un album porte déjà ce nom, veuillez en choisir un autre"
      alertControllerInstance.genericAlert(controller: controller, msg: msg)
    }
  }
}
