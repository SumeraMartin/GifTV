    //
//  GiphyService.swift
//  GifTV
//
//  Created by Martin Sumera on 25/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import RxSwift
import Alamofire
import Alamofire_Gloss
    
protocol GiphyServiceType {
    
    func downloadGif(byQuery query: String) -> Observable<GifSaved>
}
    
class GiphyService: BaseService, GiphyServiceType  {
    
    func downloadGif(byQuery query: String) -> Observable<GifSaved> {
        if query == "trending" { 
            return self.getGif(withRouter: Router.trending)
                        .flatMap { self.downloadGifThumbnail($0) }
                        .map { $0.gif }
                        .flatMap { self.downloadGif($0) }
        }
    
        return self.getGifCount(byQuery: query)
            .flatMap { self.getGif(withRouter: Router.search(query: query, offset: (0...min(1000, $0)).random)) }
            .flatMap { self.downloadGifThumbnail($0) }
            .map { $0.gif }
            .flatMap { self.downloadGif($0) }
    }
    
    private func downloadGif(_ gif: Gif) -> Observable<GifSaved> {
        return Observable.create { observer in
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(gif.id)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            let request = Alamofire
                .download(gif.images.original.url, to: destination)
                .responseData { response in
                    if let error = response.error {
                        observer.onError(error)
                    } else if let imagePath = response.destinationURL?.path {
                        observer.onNext(GifSaved(gif, imagePath))
                        observer.onCompleted()
                    }
            }
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
    
    private func downloadGifThumbnail(_ gif: Gif) -> Observable<GifSaved> {
        return Observable.create { observer in
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(gif.id)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            let request = Alamofire
                .download(gif.images.original.url, to: destination)
                .responseData { response in
                    if let error = response.error {
                        observer.onError(error)
                    } else {
                        observer.onNext(GifSaved(gif, gif.id))
                        observer.onCompleted()
                    }
            }
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
    
    private func getGifCount(byQuery query: String) -> Observable<Int> {
        return Observable.create { observer in
            let request = Alamofire
                .request(Router.count(query: query))
                .log()
                .responseObject(GifData.self) { response in
                    switch response.result {
                        case .success(let gif):
                            observer.onNext(gif.pagination.count!)
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
    
    private func getGif(byQuery query: String, withOffset offset: Int) -> Observable<Gif> {
        return Observable.create { observer in
            let request = Alamofire
                .request(Router.search(query: query, offset: offset))
                .log()
                .responseObject(GifData.self) { response in
                    switch response.result {
                    case .success(let gif):
                        observer.onNext(gif.gif[0])
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
    
    private func getGif(withRouter router: URLRequestConvertible) -> Observable<Gif> {
        return Observable.create { observer in
            let request = Alamofire
                .request(router)
                .log()
                .responseObject(GifData.self) { response in
                    switch response.result {
                    case .success(let gif):
                        observer.onNext(gif.gif[0])
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
}
    
extension GiphyService {
    
    enum Router: URLRequestConvertible {
        case search(query: String, offset: Int)
        case count(query: String)
        case trending
        
        static let baseURLString = "http://api.giphy.com/v1/gifs/"
        static let apiKey = "dc6zaTOxFJmzC"
        
        var method: HTTPMethod {
            return .get
        }
        
        func asURLRequest() throws -> URLRequest {
            let result: (path: String, parameters: Parameters) = {
                switch self {
                    case let .search(query, offset):
                        return ("search", ["q": query, "limit": 1, "offset": offset, "api_key": Router.apiKey])
                    case let .count(query):
                        return ("search", ["q": query, "limit": 0, "api_key": Router.apiKey])
                    case .trending:
                        return ("trending", ["limit": 1, "offset": (1...1000).random, "api_key": Router.apiKey])
                }
            }()
            
            let url = try Router.baseURLString.asURL()
            let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}
    
func ==(lhs: GiphyService.Router, rhs: GiphyService.Router) -> Bool {
    switch (lhs, rhs) {
        case (.trending, .trending):
            return true
        case let (.count(first), .count(second)):
            return first == second
        case let (.search(lhsFirst, lhsSecond), .search(rhsFirst, rhsSecond)):
            return lhsFirst == rhsFirst && lhsSecond == rhsSecond
        default:
            return false
    }
}
