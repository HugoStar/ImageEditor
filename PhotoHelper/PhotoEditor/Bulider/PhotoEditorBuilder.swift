//
//  PhotoEditorBuilder.swift
//  PhotoHelper
//
//  Created by Мишустин Сергеевич on 09/08/2019.
//  Copyright © 2019 Мишустин Сергеевич. All rights reserved.
//

import UIKit
import Photos

protocol PhotoEditorResultDelegate {
  func didResultImage(_ image: UIImage)
  func errorGetImage(_ errorString: String)
}

class PhotoBuilder {
  static func checkAuthorization(isAutorize: @escaping (_ authorize: Bool) -> ()) {
    let photos = PHPhotoLibrary.authorizationStatus()
    if photos == .notDetermined {
      PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
          isAutorize(true)
        } else {
          isAutorize(false)
        }
      }
    } else if photos == .authorized {
      isAutorize(true)
    }
  }
  
  static func loadEditModuleWithCurrentController(_ controller: UIViewController, image: UIImage, andDelegate delgate: PhotoEditorResultDelegate) {
    let editController = PhotoEditController(nibName: "PhotoEditController", bundle: nil)
    editController.mainImage = image
    editController.photoDelegate = delgate
    controller.navigationController?.pushViewController(editController, animated: true)
  }
  
  static func loadPhotoEditorWithCurrentController(_ controller: UIViewController, andDelegate delegate: PhotoEditorResultDelegate) {
    checkAuthorization { isAutorize in
      if isAutorize {
        //Initial
        let photoListController = PhotoListController(nibName: "PhotoListController", bundle: nil)
        let interactor = PhotoListInteractor()
        let ddm = PhotoListDDM()
        
        //Dependenses
        photoListController.interactor = interactor
        photoListController.ddm = ddm
        
        interactor.output = photoListController
        interactor.delegateModule = delegate
        
        ddm.elementHelper = interactor
        
        //Route
        if controller.navigationController != nil {
          controller.navigationController?.pushViewController(photoListController, animated: true)
        } else {
          controller.present(photoListController, animated: true, completion: nil)
        }
      } else {
        delegate.errorGetImage("у вас нет доступа для загрузки изображение")
      }
    }
  }
}
