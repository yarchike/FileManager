//
//  Settings.swift
//  fileManager
//
//  Created by Ярослав  Мартынов on 27.05.2024.
//

import Foundation


final class Settings {
    
    static let shared = Settings()
    
    var alphabetOrder: Bool {
        get {
            UserDefaults.standard.bool(forKey: "alphabetOrder")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "alphabetOrder")
        }
    }
    
    var viewPhotoSize: Bool {
        get {
            UserDefaults.standard.bool(forKey: "viewPhotoSize")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "viewPhotoSize")
        }
    }
    
    
    
//    var stores: [Store] = [KeychainStore()]
    
//    var currentStore: Store {
//        stores[currentStoreIndex]
//    }
    
    
}
