//
//  AppDelegate.swift
//  AmanRealityKitDemo
//
//  Created by Aman Joshi on 16/02/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRoot()
        return true
    }
}

extension AppDelegate {
    
    private func setRoot() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVc = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeVc")
        let navigationController = UINavigationController(rootViewController: welcomeVc)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
