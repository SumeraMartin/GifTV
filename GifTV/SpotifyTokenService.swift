//
//  SpotifyTokenService.swift
//  GifTV
//
//  Created by Martin Sumera on 03/06/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import RxSwift
import Alamofire
import Alamofire_Gloss

protocol SpotifyTokenServiceType {
    
    func getToken() -> Observable<String>
}

class SpotifyTokenService : BaseService, SpotifyTokenServiceType {

    func getToken() -> Observable<String> {
        return Observable.create { observer in
            let request = Alamofire
                .request(Router.token)
                .log()
                .responseObject(SpotifyToken.self) { response in
                    switch response.result {
                    case .success(let spotifyToken):
                        observer.onNext(spotifyToken.accessToken)
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

extension SpotifyTokenService {
    
    enum Router: URLRequestConvertible {
        case token
        
        static let baseUrl = "https://accounts.spotify.com/api/"
        
        var method: HTTPMethod {
            return .post
        }
        
        func asURLRequest() throws -> URLRequest {
            let result: (path: String, parameters: Parameters) = {
                return ("token", ["grant_type": "client_credentials"])
            }()
            
            let url = try Router.baseUrl.asURL()
            var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
            urlRequest.setValue("Basic OTY3YzIzZjFiMzVmNDU3MmIyZDEwYTY2YmRkMTAyYjU6OTM0YTQ0NmY0OTFlNGVhNWE0YzY0OWI5Zjg5YjU0ZWI=", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = method.rawValue
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}


