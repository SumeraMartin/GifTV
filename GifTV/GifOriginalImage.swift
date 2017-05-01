//
//  GifOriginalImage.swift
//  GifTV
//
//  Created by Martin Sumera on 25/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct GifOriginalImage: Decodable {
    
    let url: String
    
    public init?(json: JSON) {
        guard let url: String = "url" <~~ json else {
            return nil
        }
        self.url = url
    }
    
}
