//
//  SpotifyToken.swift
//  GifTV
//
//  Created by Martin Sumera on 03/06/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gloss

struct SpotifyToken: Decodable {
    
    let accessToken: String
    
    public init?(json: JSON) {
        guard let accessToken: String = "access_token" <~~ json else {
            return nil
        }
        self.accessToken = accessToken
    }
}
