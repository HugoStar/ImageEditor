//
//  PhotoListInteractor.swift
//  PhotoHelper
//
//  Created by Мишустин Сергеевич on 09/08/2019.
//  Copyright © 2019 Мишустин Сергеевич. All rights reserved.
//

import UIKit
import Photos

class PhotoListInteractor: PhotoListInteractorType {

  //MARK: -
  //MARK: Properties
  weak var output: PhotoListOutput!
  var delegateModule: PhotoEditorResultDelegate!
  var imageArray: [UIImage] = []
  
  deinit { print("PhotoListInteractor deinit") }
  
  //MARK: -
  //MARK: PhotoListInteractorType
  func loadElements() {
    imageArray = []
    DispatchQueue.global().async {
      let imgManager = PHImageManager.default()
      let requestOptions = PHImageRequestOptions()
      requestOptions.isSynchronous = true
      requestOptions.deliveryMode = .highQualityFormat
      
      let fetchOptions = PHFetchOptions()
      fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
      
      let fetchRequest: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
      
      if fetchRequest.count > 0 {
        for i in 0..<fetchRequest.count {
          imgManager.requestImage(for: fetchRequest.object(at: i) as PHAsset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, error in
            if let image = image { self.imageArray.append(image) }
          })
        }
      }
      DispatchQueue.main.async { [weak self] in
        self?.output.reload()
      }
    }
 
  }
  
  func getPhotoDelegate() -> PhotoEditorResultDelegate {
    return delegateModule
  }
  
}

extension PhotoListInteractor: PhotoListElements {
  func loadEditModuleWithImage(_ image: UIImage) {
    output.didLoadEditModuleWithImage(image)
  }
  
  func getCountImages() -> Int {
    return imageArray.count
  }
  
  func getImageAtIndex(_ index: Int) -> UIImage {
    return imageArray[index]
  }
  
  
}
