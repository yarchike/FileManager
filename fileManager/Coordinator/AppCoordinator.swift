//
//  AppCoordinator.swift
//  fileManager
//
//  Created by Ярослав  Мартынов on 28.05.2024.
//

import UIKit

class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    var rootViewCOntroller: UIViewController;
    let window:UIWindow
    
    init(windows: UIWindow) {
        self.rootViewCOntroller = UIViewController()
        self.window = windows
        let store  = KeychainStore()
        
        var step: Step = .login
        if (store.load() == "") {
            step = .password
        }
    
        let loginViewController = LoginViewController(store: store, step: step, routeToMaint: routeToMaint)
       
        
        self.rootViewCOntroller = UINavigationController(rootViewController: loginViewController)
    }
    
    func routeToMaint(){
        let tabBarController =  UITabBarController()
        let viewController = ViewController()
        let settingsViewController = SettingsViewController(updateTable: viewController.updateTable)
        settingsViewController.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 0)
        viewController.tabBarItem = UITabBarItem(title: "Папки", image: UIImage(systemName: "folder"), tag: 1)
        let controllers = [settingsViewController, viewController]
        tabBarController.viewControllers = controllers
        tabBarController.selectedIndex = 0
        UITabBar.appearance().backgroundColor = .white
        rootViewCOntroller = tabBarController
        window.switchRootViewController(tabBarController)
    }
    
}
