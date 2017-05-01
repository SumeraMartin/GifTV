//
//  UiLabel.swift
//  GifTV
//
//  Created by Martin Sumera on 25/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit

extension UILabel {
    
    func animateClick(backgroundColor color: UIColor, withDuration duration: TimeInterval) {
        let originalColor = self.layer.backgroundColor
        UIView.animate(withDuration: duration, animations: {() -> Void in
            self.layer.backgroundColor = color.cgColor
            self.layer.backgroundColor = originalColor
        })
    }
}
