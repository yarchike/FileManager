//
//  Store.swift
//  fileManager
//
//  Created by Ярослав  Мартынов on 27.05.2024.
//

import Foundation

protocol Store {
    var name: String { get }
    func load() -> String
    func save(item: String)
}


extension Store {
    func encode(item: String) -> Data? {
        try? JSONEncoder().encode(item)
    }
    
    func decode(data: Data) -> String {
        return (try? JSONDecoder().decode(String.self, from: data)) ?? ""
    }
}
