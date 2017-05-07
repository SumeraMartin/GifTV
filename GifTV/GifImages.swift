//
//  GifImage.swift
//  GifTV
//
//  Created by Martin Sumera on 25/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct GifImages: Decodable {
    
    let original: GifUrlImage
    
    let fixedWidthThumbnail: GifUrlImage
        
    public init?(json: JSON) {
        guard let original: GifUrlImage = "fixed_height" <~~ json else {
            return nil
        }
        guard let fixedWidthThumbnail: GifUrlImage = "fixed_width_downsampled" <~~ json else {
            return nil
        }
        self.original = original
        self.fixedWidthThumbnail = fixedWidthThumbnail
    }
    
}
