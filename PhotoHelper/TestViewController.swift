//
//  TestViewController.swift
//  PhotoHelper
//
//  Created by Мишустин Сергеевич on 09/08/2019.
//  Copyright © 2019 Мишустин Сергеевич. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
  
  
  @IBOutlet weak var imageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  @IBAction func buttonImageTap(_ sender: Any) {
    PhotoBuilder.loadPhotoEditorWithCurrentController(self, andDelegate: self)
  }
  
}

extension TestViewController: PhotoEditorResultDelegate {
  func errorGetImage(_ errorString: String) {
    print(errorString)
  }
  
  func didResultImage(_ image: UIImage) {
    imageView.image = image
  }
}
