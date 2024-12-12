//
//  SceneDelegate.swift
//  FindPair
//
//  Created by Aldongarov Nuraskhan on 12.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: Controller()) // Controller is your main view controller
        self.window = window
        window.makeKeyAndVisible()
    }
}
