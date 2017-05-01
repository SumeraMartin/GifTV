//
//  TrackSaved.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

struct TrackSaved {
    
    let track: Track
    
    let path: String
    
    init(_ track: Track, _ path: String) {
        self.track = track
        self.path = path
    }
}
