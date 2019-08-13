//
//  UIView+Mask.swift
//  PhotoHelper
//
//  Created by Мишустин Сергеевич on 12/08/2019.
//  Copyright © 2019 Мишустин Сергеевич. All rights reserved.
//

import UIKit

extension UIView {
  
  func setMask(with hole: CGRect){
    
    // Create a mutable path and add a rectangle that will be h
    let mutablePath = CGMutablePath()
    mutablePath.addRect(bounds)
    mutablePath.addRect(hole)
    
    // Create a shape layer and cut out the intersection
    let mask = CAShapeLayer()
    mask.path = mutablePath
    mask.fillRule = CAShapeLayerFillRule.evenOdd
    
    // Add the mask to the view
    layer.mask = mask
  }
  
}
