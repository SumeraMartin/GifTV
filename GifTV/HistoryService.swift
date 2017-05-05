//
//  HistoryService.swift
//  GifTV
//
//  Created by Martin Sumera on 01/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import RealmSwift
import RxSwift

protocol HistoryServiceType {
    
    func getAll() -> Observable<[HistoryGifTrack]>
    
    func add(fromGifTrack gif: GifTrackSaved) -> Observable<Void>
}

class HistoryService : BaseService, HistoryServiceType {
    
    func getAll() -> Observable<[HistoryGifTrack]> {
        let realm = try! Realm()
        let objects = realm.objects(HistoryGifTrack.self).reversed()
        
        return Observable.just(Array(objects))
    }
    
    func add(fromGifTrack gifTrack: GifTrackSaved) -> Observable<Void> {
        let realm = try! Realm()
        try! realm.write() {
            let authorName = gifTrack.track.track.items[0].artists[0].name
            let songName = gifTrack.track.track.items[0].songName
            let trackUrl = gifTrack.track.track.items[0].previewUrl
            let gifOriginalUrl = gifTrack.gif.gif.images.original.url

            realm.create(HistoryGifTrack.self, value: [
                authorName,
                songName,
                trackUrl,
                gifOriginalUrl,
                gifTrack.gif.gif.id
            ])
        }
        return Observable.just()
    }
}
