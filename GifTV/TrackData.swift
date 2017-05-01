    //
//  TrackData.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct TrackData: Decodable {
    
    let tracks: Track
    
    public init?(json: JSON) {
        print(json)
        guard let tracks: Track = "tracks" <~~ json else {
            return nil
        }
        self.tracks = tracks
    }
}
