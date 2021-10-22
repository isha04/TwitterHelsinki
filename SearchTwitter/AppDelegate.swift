//
//  AppDelegate.swift
//  SearchTwitter
//
//  Created by Isha Dua on 30/09/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = UINavigationController(rootViewController: SearchResultsViewController(apiHander: TwitterAPIHandler()))
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
