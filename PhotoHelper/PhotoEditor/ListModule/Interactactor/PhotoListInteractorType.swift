//
//  PhotoListInteractorInput.swift
//  PhotoHelper
//
//  Created by Мишустин Сергеевич on 09/08/2019.
//  Copyright © 2019 Мишустин Сергеевич. All rights reserved.
//

import Foundation

protocol PhotoListInteractorType: class {
  
  func loadElements()
  func getPhotoDelegate() -> PhotoEditorResultDelegate
  
}
