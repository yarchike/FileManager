//
//  Content.swift
//  fileManager
//
//  Created by Ярослав  Мартынов on 26.05.2024.
//

import Foundation

struct Content {
    var path: String = ""
    
    var title:String {
        return NSString(string: path).lastPathComponent
    }
    
    init(path: String) {
        self.path = path
    }
    
}
