//
//  GifImage.swift
//  GifTV
//
//  Created by Martin Sumera on 25/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct GifImages: Decodable {
    
    let original: GifOriginalImage
    
    public init?(json: JSON) {
        guard let original: GifOriginalImage = "original" <~~ json else {
            return nil
        }
        self.original = original
    }
    
}
