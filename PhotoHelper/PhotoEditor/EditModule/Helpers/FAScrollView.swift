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
  var needCenterAfterZoom = false
  var imageToDisplay:UIImage? = nil{
    didSet{
      guard let imageToDisplay = imageToDisplay else { return }
      zoomScale = 1.0
      minimumZoomScale = 1.0
      imageView.image = imageToDisplay
      imageView.backgroundColor = .white
      imageView.frame.size = sizeForImageToDisplay()
      minimumZoomScale = minZoom()
      imageView.contentMode = .scaleAspectFill
      imageView.backgroundColor = .red
      imageView.center = center
      contentSize = imageView.frame.size
      gridView.frame = maskFrame
      gridView.isUserInteractionEnabled = false
      addSubview(gridView)
      
      helperMaskView.frame = bounds
      helperMaskView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75)
      addSubview(helperMaskView)
      helperMaskView.setMask(with: CGRect(x: maskFrame.origin.x, y: maskFrame.origin.y - 64,
                                          width: maskFrame.size.width, height: maskFrame.size.height))
      
    }
  }
  
  var maskFrame: CGRect = .zero
  var gridView: UIView = Bundle.main.loadNibNamed("FAGridView", owner: nil, options: nil)?.first as! UIView
  var helperMaskView: UIView = UIView()
  
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
    if !isAnimation {
      centerScrollView(self, whithAnimation: false)
    }
  }
  
  func loadMaskeFrame(_ frame: CGRect) {
    maskFrame = frame
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
  }
  
  private func sizeForImageToDisplay() -> CGSize {
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
  
  func minZoom() -> CGFloat {
    let diffWidth = maskFrame.width / imageView.bounds.width
    let diffHeight = maskFrame.height / imageView.bounds.height
    let giff = max(diffWidth, diffHeight)
    return giff
  }
  
  
  private func zoomScaleWithNoWhiteSpaces() -> CGFloat{
    let imageViewSize:CGSize  = imageView.bounds.size
    let scrollViewSize:CGSize = bounds.size;
    let widthScale:CGFloat  = scrollViewSize.width / imageViewSize.width
    let heightScale:CGFloat = scrollViewSize.height / imageViewSize.height
    return max(widthScale, heightScale)
  }
  
  private func centerScrollView(_ scrollView: UIScrollView, whithAnimation animated: Bool) {
    let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
    let centerOffsetY = (scrollView.contentSize.height - scrollView.frame.size.height) / 2
    let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
    scrollView.setContentOffset(centerPoint, animated: animated)
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
    var frame:CGRect = gridView.frame;
    frame.origin.x = maskFrame.origin.x + scrollView.contentOffset.x
    frame.origin.y = maskFrame.origin.y - 64 + scrollView.contentOffset.y
    gridView.frame = frame
    
    var tempMaskFrame = helperMaskView.frame
    tempMaskFrame.origin.x = scrollView.contentOffset.x
    tempMaskFrame.origin.y = scrollView.contentOffset.y
    helperMaskView.frame = tempMaskFrame
    
    if scrollView.zoomScale < 1 && !needCenterAfterZoom { needCenterAfterZoom = true }
    
    let diffWith = round((imageView.bounds.width * scrollView.zoomScale)) - maskFrame.width
    let diffHeight = round((imageView.bounds.height * scrollView.zoomScale)) - maskFrame.width
    
    let resWidth = min(max(0, diffWith), maskFrame.origin.x)
    let resHeght = min(max(0, diffHeight), maskFrame.origin.y - 64)
    contentInset = UIEdgeInsets(top: resHeght, left: resWidth, bottom: resHeght, right: resWidth)
  }
  
}
