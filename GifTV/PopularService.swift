//
//  PopularService.swift
//  GifTV
//
//  Created by Martin Sumera on 05/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import RealmSwift
import RxSwift

protocol PopularServiceType {
    
    func getAll() -> Observable<[PopularGifTrack]>
    
    func add(_ gif: GifTrackSaved) -> Observable<Void>
    
    func remove(_ gif: GifTrackSaved) -> Observable<Void>
}

class PopularService : BaseService, PopularServiceType {

    func getAll() -> Observable<[PopularGifTrack]> {
        let realm = try! Realm()
        let objects = realm.objects(PopularGifTrack.self).reversed()
        
        return Observable.just(Array(objects))
    }
    
    func add(_ gifTrack: GifTrackSaved) -> Observable<Void> {
        let realm = try! Realm()
        try! realm.write() {
            let authorName = gifTrack.track.track.items[0].artists[0].name
            let songName = gifTrack.track.track.items[0].songName
            let trackUrl = gifTrack.track.track.items[0].previewUrl
            let gifOriginalUrl = gifTrack.gif.gif.images.original.url
            
            realm.create(PopularGifTrack.self, value: [
                authorName,
                songName,
                trackUrl,
                gifOriginalUrl,
                gifTrack.gif.gif.id
                ])
        }
        return Observable.just()
    }
    
    func remove(_ gif: GifTrackSaved) -> Observable<Void> {
        let realm = try! Realm()
        if let item = realm.objects(PopularGifTrack.self).first {
            realm.delete(item)
        }
        return Observable.just()
    }
}
