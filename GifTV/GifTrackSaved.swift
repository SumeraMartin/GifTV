//
//  GifTrack.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

struct GifTrackSaved {
    
    let gif: GifSaved
    
    let track: TrackSaved
    
    var authorName: String {
        get {
            return track.track.items[0].artists[0].name
        }
    }
    
    var songName: String {
        get {
            return track.track.items[0].songName
        }
    }
    
    init(_ gif: GifSaved, _ track: TrackSaved) {
        self.gif = gif
        self.track = track
    }
}
