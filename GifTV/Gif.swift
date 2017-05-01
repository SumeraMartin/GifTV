//
//  Gif.swift
//  GifTV
//
//  Created by Martin Sumera on 25/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct Gif: Decodable {
    
    let id: String
    
    let slug: String
    
    let images: GifImages
    
    public init?(json: JSON) {
        guard let id: String = "id" <~~ json else {
            return nil
        }
        guard let slug: String = "slug" <~~ json else {
            return nil
        }
        guard let images: GifImages = "images" <~~ json else {
            return nil
        }
        
        self.id = id
        self.slug = slug
        self.images = images
    }
}
