//
//  GifTrackService.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import RxSwift
import Alamofire
import Alamofire_Gloss

protocol GifTrackServiceType {
    
    func get(byQuery query: String) -> Observable<GifTrackSaved>
}

class GifTrackService: BaseService, GifTrackServiceType {
    
    func get(byQuery query: String) -> Observable<GifTrackSaved> {
        return self.provider.giphyService
            .downloadGif(byQuery: query)
            .flatMap { gif in
                self.provider.spotifyService
                    .downloadTrack(byQuery: self.createTags(from: gif, or: query, separator: " OR "))
                    .map { track in GifTrackSaved(gif, track) }
            }
            .debug("GIFTRACK")
            .retry()
    }
    
    private func createTags(from gifSaved: GifSaved, or defaultQuery: String, separator: String = " ") -> String {
        let tags = gifSaved.gif.slug
            .replacingOccurrences(of: "-" + gifSaved.gif.id, with: "")
            .replacingOccurrences(of: gifSaved.gif.id, with: "")
            .components(separatedBy: "-")
        
        if tags.count >= 2 {
            return tags[0..<2].joined(separator: separator)
        }
        if tags.count == 1 && !tags[0].isEmpty {
            return tags[0]
        }
        return defaultQuery
    }
}
