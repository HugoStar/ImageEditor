//
//  AppDelegate.swift
//  PhotoHelper
//
//  Created by Мишустин Сергеевич on 08/08/2019.
//  Copyright © 2019 Мишустин Сергеевич. All rights reserved.
//

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    guard let window = self.window else { fatalError("error window") }
    window.backgroundColor = UIColor.white
    
    let nav = UINavigationController()
    nav.navigationBar.isHidden = true
    let testController = TestViewController(nibName: "TestViewController", bundle: nil)
    nav.viewControllers = [testController]
    window.rootViewController = nav
    window.makeKeyAndVisible()
    

    return true
  }

}

