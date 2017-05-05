//
//  TrackItem.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct TrackItem: Decodable {
    
    let id: String
    
    let previewUrl: String
    
    let songName: String
    
    let artists: [TrackArtist]
    
    public init?(json: JSON) {
        guard let id: String = "id" <~~ json else {
            return nil
        }
        guard let previewUrl: String = "preview_url" <~~ json else {
            return nil
        }
        guard let songName: String = "name" <~~ json else {
            return nil
        }
        guard let artists: [TrackArtist] = "artists" <~~ json else {
            return nil
        }
        self.id = id
        self.previewUrl = previewUrl
        self.songName = songName
        self.artists = artists
    }
}
