//
//  UIImage.swift
//  GifTV
//
//  Created by Martin Sumera on 25/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit

class UIImageChanger {

    let image: UIImageView
    
    let images: [UIImage]
    
    var index: Int
    
    var timer: Timer?
    
    init(forImage image: UIImageView, withImages images: [UIImage]) {
        self.image = image
        self.images = images
        self.index = 0
    }
    
    func animate(withDelay delay: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    @objc func changeImage() {
        self.image.image = images[index]
        self.index = index == images.count - 1 ? 0 : index + 1
    }
}
