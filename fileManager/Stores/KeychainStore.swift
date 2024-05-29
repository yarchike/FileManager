//
//  KeychainStore.swift
//  fileManager
//
//  Created by Ярослав  Мартынов on 27.05.2024.
//

import Foundation
import KeychainSwift


final class KeychainStore: Store {
    
    var name: String {
        "Keychain"
    }
    
    func load() -> String {
        if let data = KeychainSwift().getData("database") {
           return decode(data: data)
        } else {
            return ""
        }
    }
    
    func save(item: String) {
        if let data = encode(item: item) {
            KeychainSwift().set(data, forKey: "database")
        }
    }

}
