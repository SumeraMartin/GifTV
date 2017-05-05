//
//  TrackArtist.swift
//  GifTV
//
//  Created by Martin Sumera on 02/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct TrackArtist: Decodable {

    let name: String
    
    public init?(json: JSON) {
        guard let name: String = "name" <~~ json else {
            return nil
        }
        self.name = name
    }
}
