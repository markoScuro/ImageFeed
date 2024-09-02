//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 04.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
    // MARK: Public properties
    
    var window: UIWindow?
    
    // MARK: Public methods
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
      
    }
}

