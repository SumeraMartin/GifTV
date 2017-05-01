//
//  Category.swift
//  GifTV
//
//  Created by Martin Sumera on 22/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

struct Category {
    
    var title: String
    var searchValue: String

    init(_ title: String) {
        self.init(title, searchValue: title.lowercased())
    }
    
    init(_ title: String, searchValue: String) {
        self.title = title
        self.searchValue = searchValue
    }
    
    static func trending() -> Category {
        return Category("Trending")
    }
    
    static func random() -> Category {
        return Category("Random")
    }
}
