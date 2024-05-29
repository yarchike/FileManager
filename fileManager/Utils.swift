//
//  Utils.swift
//  fileManager
//
//  Created by Ярослав  Мартынов on 28.05.2024.
//

import Foundation
import UIKit

//class Utils {
//    static func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
//        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
//        if animated {
//            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
//                let oldState: Bool = UIView.areAnimationsEnabled
//                UIView.setAnimationsEnabled(false)
//                window.rootViewController = rootViewController
//                UIView.setAnimationsEnabled(oldState)
//            }, completion: { (finished: Bool) -> () in
//                if (completion != nil) {
//                    completion!()
//                }
//            })
//        } else {
//            window.rootViewController = rootViewController
//        }
//    }
//}

extension UIWindow {
    
    func switchRootViewController(_ viewController: UIViewController,  animated: Bool = true, duration: TimeInterval = 0.5, options: UIView.AnimationOptions = .transitionFlipFromRight, completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}
