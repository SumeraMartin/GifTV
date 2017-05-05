//
//  DownloadService.swift
//  GifTV
//
//  Created by Martin Sumera on 01/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import RealmSwift
import RxSwift
import Alamofire

protocol DownloadServiceType {
    
    func download(fromUrl url: String, to destinationDir: FileManager.SearchPathDirectory, withName name: String) -> Observable<String>
}

class DownloadService : BaseService, DownloadServiceType {
    
    func download(fromUrl url: String, to destinationDir: FileManager.SearchPathDirectory, withName name: String) -> Observable<String> {
        return Observable.create { observer in
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: destinationDir, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(name)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            let request = Alamofire
                .download(url, to: destination)
                .responseData { response in
                    if let error = response.error {
                        observer.onError(error)
                    } else if let imagePath = response.destinationURL?.path {
                        observer.onNext(imagePath)
                        observer.onCompleted()
                    }
            }
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
}
