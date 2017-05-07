//
//  Range.swift
//  GifTV
//
//  Created by Martin Sumera on 29/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import Foundation

extension CountableClosedRange where Bound: Integer {
    
    var random: Int {
        return Int(lowerBound.toIntMax()) + Int(arc4random_uniform(UInt32((upperBound - lowerBound + 1).toIntMax())))
    }
    
    func random(_ n: Int) -> [Int] {
        var result: [Int] = []
        result.reserveCapacity(n)
        (0..<n).forEach({ _ in result.append(random) })
        return result
    }
}
