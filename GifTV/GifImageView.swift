//
//  GifImageView.swift
//  GifTV
//
//  Created by Martin Sumera on 01/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Gifu

extension GIFImageView {
    
    func animate(fromPath path: String) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documentsURL.appendingPathComponent(path)
            let data = try Data.init(contentsOf: url, options: [])
            self.animate(withGIFData: data)
        } catch {
            print(error)
        }
    }
}
