//
//  FAScrollView.swift
//  FAImageCropper
//
//  Created by Fahid Attique on 12/02/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit

class FAScrollView: UIScrollView{
  
  // MARK: Class properties
  
  var imageView:UIImageView = UIImageView()
  var borderView: UIView = UIView()
  var imageToDisplay:UIImage? = nil{
    didSet{
      zoomScale = 1.0
      minimumZoomScale = 1.0
      imageView.image = imageToDisplay
      imageView.frame.size = UIScreen.main.bounds.size
      imageView.contentMode = .scaleAspectFit
      imageView.center = center
      contentSize = imageView.frame.size
      contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
//  var gridView: UIView = Bundle.main.loadNibNamed("FAGridView", owner: nil, options: nil)?.first as! UIView
  var customMaskView: UIView!
  let mainRect = UIScreen.main.bounds

  // MARK : Class Functions
  
  override func awakeFromNib() {
    super.awakeFromNib()
    viewConfigurations()
  }
  
  func updateLayout() {
    imageView.center = center;
    var frame:CGRect = imageView.frame;
    if (frame.origin.x < 0) { frame.origin.x = 0 }
    if (frame.origin.y < 0) { frame.origin.y = 0 }
    imageView.frame = frame
  }
  
  func zoom(isAnimation: Bool) {
    setZoomScale(zoomScaleWithNoWhiteSpaces(), animated: isAnimation)
    updateLayout()
  }
  
  // MARK: Private Functions
  
  private func viewConfigurations(){
    
    clipsToBounds = false;
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    alwaysBounceHorizontal = true
    alwaysBounceVertical = true
    bouncesZoom = true
    decelerationRate = UIScrollView.DecelerationRate.fast
    delegate = self
    maximumZoomScale = 5.0
    addSubview(imageView)

//    gridView.frame = frame
//    gridView.frame = CGRect(x: 0, y: (frame.height - frame.width) / 2, width: frame.width, height: frame.width)
//    gridView.isUserInteractionEnabled = false
//    addSubview(gridView)
    
    customMaskView = UIView(frame: CGRect(x: 0, y: 0, width: mainRect.width, height: mainRect.height))
    customMaskView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7485695423)
    addSubview(customMaskView)
    setMask(with: CGRect(x: 0, y: (mainRect.height - mainRect.width) / 2, width: mainRect.width, height: mainRect.width), in: customMaskView)

  }
  
  
  private func setMask(with hole: CGRect, in view: UIView){
    
    // Create a mutable path and add a rectangle that will be h
    let mutablePath = CGMutablePath()
    mutablePath.addRect(view.bounds)
    mutablePath.addRect(hole)
    
    // Create a shape layer and cut out the intersection
    let mask = CAShapeLayer()
    mask.path = mutablePath
    mask.fillRule = CAShapeLayerFillRule.evenOdd
    
    // Add the mask to the view
    view.layer.mask = mask
    
  }

  private func sizeForImageToDisplay() -> CGSize{
    var actualWidth:CGFloat = imageToDisplay!.size.width
    var actualHeight:CGFloat = imageToDisplay!.size.height
    var imgRatio:CGFloat = actualWidth/actualHeight
    let maxRatio:CGFloat = frame.size.width/frame.size.height
    
    if imgRatio != maxRatio{
      if(imgRatio < maxRatio){
        imgRatio = frame.size.height / actualHeight
        actualWidth = imgRatio * actualWidth
        actualHeight = frame.size.height
      }
      else{
        imgRatio = frame.size.width / actualWidth
        actualHeight = imgRatio * actualHeight
        actualWidth = frame.size.width
      }
    }
    else {
      imgRatio = frame.size.width / actualWidth
      actualHeight = imgRatio * actualHeight
      actualWidth = frame.size.width
    }
    return  CGSize(width: actualWidth, height: actualHeight)
  }
  
  private func zoomScaleWithNoWhiteSpaces() -> CGFloat{
    let imageViewSize:CGSize  = imageView.bounds.size
    let scrollViewSize:CGSize = bounds.size;
    let widthScale:CGFloat  = scrollViewSize.width / imageViewSize.width
    let heightScale:CGFloat = scrollViewSize.height / imageViewSize.height
    return max(widthScale, heightScale)
  }
  
}



extension FAScrollView:UIScrollViewDelegate{
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    updateLayout()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    var frame:CGRect = gridView.frame;
//    frame.origin.x = scrollView.contentOffset.x
//    frame.origin.y = scrollView.contentOffset.y + ((frame.height - frame.width) / 2) + 64
//    gridView.frame = frame
    
    var frameMask: CGRect = customMaskView.frame
    frameMask.origin.x = scrollView.contentOffset.x
    frameMask.origin.y = scrollView.contentOffset.y
    customMaskView.frame = frameMask


  }
  
}
