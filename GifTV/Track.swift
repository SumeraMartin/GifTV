//
//  Track.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct Track: Decodable {
    
    let total: Int
    
    let items: [TrackItem]
    
    public init?(json: JSON) {
        guard let total: Int = "total" <~~ json else {
            return nil
        }
        guard let items: [TrackItem] = "items" <~~ json else {
            return nil
        }
        self.total = total
        self.items = items
    }
}
