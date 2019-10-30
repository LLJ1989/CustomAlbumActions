//
//  MediaCollectionViewCell.swift
//  CustomAlbumActions
//
//  Created by Lucas Lombard on 29/10/2019.
//  Copyright © 2019 Lucas Lombard. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {

  // MARK: - Outlets
  @IBOutlet weak var buttonAction: UIButton!
  @IBOutlet weak var imageView: UIImageView!

  // MARK: - Methodes
  func setCell(image: UIImage) {
    imageView.image = image
  }
}
