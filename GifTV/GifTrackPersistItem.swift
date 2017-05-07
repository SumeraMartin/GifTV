//
//  GifTrackPersistItem.swift
//  GifTV
//
//  Created by Martin Sumera on 05/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import RealmSwift

class GifTrackPersistItem : Object {
    
    dynamic var trackName = ""
    
    dynamic var trackArtistName = ""
    
    dynamic var trackUrl = ""
    
    dynamic var gifOriginalUrl = ""
    
    dynamic var gifLocalPath = ""
}
