//
//  Pagination.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct Pagination: Decodable {
    
    let count: Int
    
    public init?(json: JSON) {
        guard let count: Int = "total_count" <~~ json else {
            return nil
        }
        self.count = count
    }
    
}

