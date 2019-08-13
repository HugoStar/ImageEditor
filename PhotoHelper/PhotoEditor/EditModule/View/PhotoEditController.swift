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
  @IBOutlet weak var maskaView: UIView!
  
  //MARK: -
  //MARK: Properties
  var photoDelegate: PhotoEditorResultDelegate!
  var mainImage: UIImage!
  var isFirstLoad = true

  //MARK: -
  //MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    labelTitle.text = "EDITING"
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if isFirstLoad {
      view.layoutIfNeeded()
      scrollView.maskFrame = maskaView.frame
      scrollView.imageToDisplay = mainImage
      scrollView.zoom(isAnimation: false)
      isFirstLoad = false
    }
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
    navigationController?.popToRootViewController(animated: true)
  }
  
  //MARK: -
  //MARK: Private
  private func captureVisibleRect() -> UIImage{
    var croprect = CGRect.zero
    let xOffset = (scrollView.imageToDisplay?.size.width)! / scrollView.contentSize.width
    let yOffset = (scrollView.imageToDisplay?.size.height)! / scrollView.contentSize.height
    
    croprect.origin.x = (scrollView.contentOffset.x + scrollView.contentInset.right) * xOffset
    croprect.origin.y = (scrollView.contentOffset.y + scrollView.contentInset.top - 64) * yOffset
    croprect.origin.x = max(croprect.origin.x, 0)
    croprect.origin.y = max(croprect.origin.y, 0)

    let normalizedWidth = ((scrollView?.frame.width)! - maskaView.frame.origin.x * 2) / (scrollView?.contentSize.width)!
    croprect.size.width = scrollView.imageToDisplay!.size.width * normalizedWidth
    croprect.size.height = scrollView.imageToDisplay!.size.width * normalizedWidth

    let toCropImage = scrollView.imageView.image?.fixImageOrientation()
    let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
    let cropped = UIImage(cgImage: cr!)
    
    return cropped
    
  }
}
