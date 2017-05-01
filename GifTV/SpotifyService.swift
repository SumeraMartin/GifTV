//
//  SpotifyService.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import RxSwift
import Alamofire
import Alamofire_Gloss

protocol SpotifyServiceType {
    
    func downloadTrack(byQuery query: String) -> Observable<TrackSaved>
}

class SpotifyService : BaseService, SpotifyServiceType {
    
    func downloadTrack(byQuery query: String) -> Observable<TrackSaved> {
        
        URLCache.shared.removeAllCachedResponses()
        
        return self.getTrackCount(byQuery: query)
            .flatMap { count in self.getTrack(byQuery: query, withOffset: (0...min(100000,count)).random) }
            .flatMap { track in self.downloadTrack(track) }
    }
    
    private func getTrackCount(byQuery query: String) -> Observable<Int> {
        return Observable.create { observer in
            let request = Alamofire
                .request(Router.count(query: query))
                .log()
                .responseObject(TrackData.self) { response in
                    switch response.result {
                        case .success(let trackData):
                            observer.onNext(trackData.tracks.total)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                    }
            }
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
    
    private func getTrack(byQuery query: String, withOffset offset: Int) -> Observable<Track> {
        return Observable.create { observer in
            let request = Alamofire
                .request(Router.search(query: query, offset: offset))
                .log()
                .responseObject(TrackData.self) { response in
                    switch response.result {
                    case .success(let trackData):
                        observer.onNext(trackData.tracks)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
    
    private func downloadTrack(_ track: Track) -> Observable<TrackSaved> {
        return Observable.create { observer in
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(track.items[0].id)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            if track.items.count == 0 {
                observer.onError(SpotifyError.noTrack)
                return Disposables.create()
            }
            
            let request = Alamofire
                .download(track.items[0].previewUrl, to: destination)
                .responseData { response in
                    if let error = response.error {
                        observer.onError(error)
                    } else if let trackPath = response.destinationURL?.path {
                        observer.onNext(TrackSaved(track, trackPath))
                        observer.onCompleted()
                    }
            }
                
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
}

extension SpotifyService {
    
    enum Router: URLRequestConvertible {
        case search(query: String, offset: Int)
        case count(query: String)
        
        static let baseUrl = "https://api.spotify.com/v1/"
        
        var method: HTTPMethod {
            return .get
        }
        
        func asURLRequest() throws -> URLRequest {
            let result: (path: String, parameters: Parameters) = {
                switch self {
                    case let .search(query, offset):
                        return ("search", ["type": "track", "limit": 1, "offset": offset, "q": query])
                    case let .count(query):
                        return ("search", ["type": "track", "limit": 1, "q": query])
                }
            }()
            
            let url = try Router.baseUrl.asURL()
            let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}

enum SpotifyError : Error {
    case noTrack
}

