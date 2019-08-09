//
//  PhotoListDDM.swift
//  PhotoHelper
//
//  Created by Мишустин Сергеевич on 09/08/2019.
//  Copyright © 2019 Мишустин Сергеевич. All rights reserved.
//

import UIKit

protocol PhotoListDDMType: class {
  func dataSourceForPhotoList(_ photoList: UICollectionView) -> UICollectionViewDataSource
  func delegateForPhotoList(_ photoList: UICollectionView) -> UICollectionViewDelegate
}

protocol PhotoListElements: class {
  func getCountImages() -> Int
  func getImageAtIndex(_ index: Int) -> UIImage
  func loadEditModuleWithImage(_ image: UIImage)
}

class PhotoListDDM: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  //MARK: - Properties
  weak var elementHelper: PhotoListElements!
  
  deinit { print("PhotoListDDM deinit") }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return elementHelper.getCountImages()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let image = elementHelper.getImageAtIndex(indexPath.row)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoItemCell
    cell.img.image = image
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    return CGSize(width: width / 3 - 1.5, height: width / 3 - 1.5)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let image = elementHelper.getImageAtIndex(indexPath.row)
    elementHelper.loadEditModuleWithImage(image)
  }

}

extension PhotoListDDM: PhotoListDDMType {
  func dataSourceForPhotoList(_ photoList: UICollectionView) -> UICollectionViewDataSource {
    return self
  }
  
  func delegateForPhotoList(_ photoList: UICollectionView) -> UICollectionViewDelegate {
    return self
  }
}
