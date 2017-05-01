//
//  GifSaved.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

struct GifSaved {
    
    let gif: Gif
    
    let path: String
    
    init(_ gif: Gif, _ path: String) {
        self.gif = gif
        self.path = path
    }
}
