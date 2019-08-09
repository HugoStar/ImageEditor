//
//  PhotoListController.swift
//  PhotoHelper
//
//  Created by Мишустин Сергеевич on 09/08/2019.
//  Copyright © 2019 Мишустин Сергеевич. All rights reserved.
//

import UIKit

protocol PhotoListOutput: class {
  func reload()
  func didLoadEditModuleWithImage(_ image: UIImage)
}

class PhotoListController: UIViewController {
  
  //MARK: -
  //MARK: Outlets
  @IBOutlet weak var activityLoad: UIActivityIndicatorView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var buttonBack: UIButton!
  @IBOutlet weak var labelTitle: UILabel!

  //MARK: -
  //MARK: Properties
  var interactor: PhotoListInteractorType!
  var ddm: PhotoListDDMType!

  //MARK: -
  //MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    labelTitle.text = "PHOTOS"
    labelTitle.textColor = .white
    collectionView.dataSource = ddm.dataSourceForPhotoList(collectionView)
    collectionView.delegate = ddm.delegateForPhotoList(collectionView)
    collectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.backgroundColor = UIColor.black
    collectionView.contentInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    interactor.loadElements()
  }
  
  deinit { print("PhotoListController deinit") }

  //MARK: -
  //MARK: Actions and changes
  @IBAction func buttonBackTap(_ sender: UIButton) {
    if self.navigationController != nil {
      self.navigationController?.popViewController(animated: true)
    }
  }
}

extension PhotoListController: PhotoListOutput {
  func didLoadEditModuleWithImage(_ image: UIImage) {
    let photoDelegate = interactor.getPhotoDelegate()
    PhotoBuilder.loadEditModuleWithCurrentController(self, image: image, andDelegate: photoDelegate)
  }
  
  func reload() {
    activityLoad.stopAnimating()
    collectionView.reloadData()
  }
}

//MARK: -
//MARK: PhotoListCell
class PhotoItemCell: UICollectionViewCell {
  var img = UIImageView()
  override init(frame: CGRect) {
    super .init(frame: frame)
    img.contentMode = .scaleAspectFill
    img.clipsToBounds = true
    self.addSubview(img)
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    img.frame = self.bounds
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("fatal error")
  }
}
