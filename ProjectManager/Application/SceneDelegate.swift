//
//  SceneDelegate.swift
//  ProjectManager
//
//  Created by idinaloq on 2023/12/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let mainViewController = ViewController() // 맨 처음 보여줄 ViewController

        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
    }


}

