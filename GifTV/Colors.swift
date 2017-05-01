//
//  Colors.swift
//  GifTV
//
//  Created by Martin Sumera on 22/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func orange() -> UIColor {
        return create(redValue: 246, greenValue: 96, blueValue: 61, alpha: 1.0)
    }
    
    static func create(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}
