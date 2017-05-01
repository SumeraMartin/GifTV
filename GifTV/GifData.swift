//
//  GifData.swift
//  GifTV
//
//  Created by Martin Sumera on 27/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct GifData: Decodable {

    let gif: [Gif]
    
    let pagination: Pagination
    
    public init?(json: JSON) {
        print(json)
        guard let gif: [Gif] = "data" <~~ json else {
            return nil
        }
        guard let pagination: Pagination = "pagination" <~~ json else {
            return nil
        }
        
        self.gif = gif
        self.pagination = pagination
    }
}
