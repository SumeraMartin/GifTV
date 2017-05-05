//
//  Alamofire.swift
//  GifTV
//
//  Created by Martin Sumera on 27/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Alamofire

extension Request {
    public func log() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}
