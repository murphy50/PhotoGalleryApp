//
//  SceneDelegate.swift
//  testHA
//
//  Created by murphy on 25.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let coordinator = AppCoordinator(root: UINavigationController())
        window.rootViewController = coordinator.start()
        self.window = window
        window.makeKeyAndVisible()
    }
}
