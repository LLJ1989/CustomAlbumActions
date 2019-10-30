//
//  RemoveMediaViewController.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 29/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//  swiftlint:disable force_cast line_length

import UIKit
import Photos

class RemoveMediaViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var dismissButton: UIButton!
  @IBOutlet weak var infosLB: UILabel!
  @IBOutlet weak var albumPicker: UIPickerView!
  @IBOutlet weak var openAlbumButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: - Properties
  let albumManagerInstance = AlbumManager()
  var selectedAlbum = String()
  var assetCollection: PHAssetCollection!
  var photosAsset: PHFetchResult<AnyObject>!
  var assetThumbnailSize: CGSize!
  var assetRealSize = CGSize(width: 3024, height: 4032)
  var currentAsset: PHAsset!
  var currentImage: UIImage?
  var onceOnly = false
  var indexPhoto: Int!
  var albumList: [String] = []

  // MARK: - Methodes
  override func viewDidLoad() {
    super.viewDidLoad()
    setAlbumListPicker()
    setImage()
    setCollectionView()
  }

  // MARK: - Action
  @IBAction func didTapDismissButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - This extension manage displaying selected album
extension RemoveMediaViewController {
  // MARK: - Action
  @IBAction func didTapOpenAlbumButton(_ sender: Any) {
    setImage()
  }
}

// MARK: - This extension manage CollectionView
extension RemoveMediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func setCollectionView() {
    collectionView.dataSource = self ; collectionView.delegate = self
  }
  private func setImage() {
    var album = String()
    if selectedAlbum == "" {
      album = albumList[0]
    } else {
      album = selectedAlbum
    }
    guard let albumTo = albumManagerInstance.getSpecificAlbum(name: album) else {return}
    assetCollection = albumTo
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      let cellSize = layout.itemSize
      self.assetThumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
    }
    photosAsset = ((PHAsset.fetchAssets(in: albumTo, options: nil) as AnyObject) as! PHFetchResult<AnyObject>)
    collectionView.reloadData()
  }

  // MARK: - Methodes
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return assetCollection.estimatedAssetCount
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCollectionViewCell else {return UICollectionViewCell()}
    let asset: PHAsset = self.photosAsset[indexPath.item] as! PHAsset
    currentAsset = asset
    PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFit, options: nil) { (result, infos) in
      if result != nil {
        cell.setCell(image: result!)
      } else {
        print(infos as Any)
      }
    }
    if asset.mediaType == .image { cell.contentView.backgroundColor = .blue}
    if asset.mediaType == .video { cell.contentView.backgroundColor = .green }
    cell.buttonAction.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    // MARK: - This next line is to get cell image index
    cell.buttonAction.tag = indexPath.row
    return cell
  }
  @objc func buttonAction(sender: Any) {
    // MARK: - This three next line are for get and use cell image index
    let sender = sender as! UIButton
    indexPhoto = sender.tag
    let asset: PHAsset = self.photosAsset[indexPhoto] as! PHAsset
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Supprimer", style: .default, handler: { (_) in
      self.removeMedia(asset: asset)
    }))
    actionSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
    self.present(actionSheet, animated: true, completion: nil)
  }
  private func removeMedia(asset: PHAsset) {
    albumManagerInstance.removeMedia(controller: self, asset: asset)
  }
}

// MARK: - This extension manage Album list Picker
extension RemoveMediaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  // MARK: - Methodes
  func setAlbumListPicker() {
    albumList = albumManagerInstance.getListofAlbum()
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
