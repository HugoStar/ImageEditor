//
//  PhotoEditController.swift
//  PhotoHelper
//
//  Created by Мишустин Сергеевич on 09/08/2019.
//  Copyright © 2019 Мишустин Сергеевич. All rights reserved.
//

import UIKit

class PhotoEditController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
  
  //MARK: -
  //MARK: Outlets
  
  @IBOutlet weak var scrollContainterView: UIView!
  @IBOutlet weak var labelTitle: UILabel!
  @IBOutlet weak var scrollView: FAScrollView!
  
  //MARK: -
  //MARK: Properties
  var photoDelegate: PhotoEditorResultDelegate!
  var mainImage: UIImage!


  //MARK: -
  //MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    labelTitle.text = "EDITING"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    scrollView.imageToDisplay = mainImage
    scrollView.zoom(isAnimation: false)
    scrollView.contentInset = UIEdgeInsets(top: (view.frame.height - view.frame.width) / 2, left: 0,
                                           bottom: (view.frame.height - view.frame.width) / 2 - 64, right: 0)
  }
  
  //MARK: -
  //MARK: Actions and changes
  @IBAction func buttonBackTap(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  
  @IBAction func buttonBaseSizeTap(_ sender: UIButton) {
    scrollView.zoom(isAnimation: true)
  }
  
  
  @IBAction func buttonCropTap(_ sender: Any) {
    let croppedImage = captureVisibleRect()
    photoDelegate.didResultImage(croppedImage)
  }
  
  //MARK: -
  //MARK: Private
  
  private func captureVisibleRect() -> UIImage{
    
    var croprect = CGRect.zero
    let xOffset = (scrollView.imageToDisplay?.size.width)! / scrollView.contentSize.width;
    let yOffset = (scrollView.imageToDisplay?.size.height)! / scrollView.contentSize.height;
    
    croprect.origin.x = scrollView.contentOffset.x * xOffset;
    croprect.origin.y = scrollView.contentOffset.y * yOffset;
    
    let normalizedWidth = (scrollView?.frame.width)! / (scrollView?.contentSize.width)!
    let normalizedHeight = (scrollView?.frame.height)! / (scrollView?.contentSize.height)!
    
    croprect.size.width = scrollView.imageToDisplay!.size.width * normalizedWidth
    croprect.size.height = scrollView.imageToDisplay!.size.height * normalizedHeight
    
    let toCropImage = scrollView.imageView.image?.fixImageOrientation()
    let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
    let cropped = UIImage(cgImage: cr!)
    
    return cropped
    
  }
  private func isSquareImage() -> Bool{
    let image = scrollView.imageToDisplay
    if image?.size.width == image?.size.height { return true }
    else { return false }
  }
  
  //MARK: -
  //MARK: Publick

  func displayImageInScrollView(image:UIImage){
    self.scrollView.imageToDisplay = image
  }
  
  func replicate(_ image:UIImage) -> UIImage? {
    
    guard let cgImage = image.cgImage?.copy() else {
      return nil
    }
    
    return UIImage(cgImage: cgImage,
                   scale: image.scale,
                   orientation: image.imageOrientation)
  }

}
