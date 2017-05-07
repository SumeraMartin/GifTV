//
//  PopularGifTrackCell.swift
//  GifTV
//
//  Created by Martin Sumera on 06/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit
import Gifu

class PopularGifTrackCell : UITableViewCell {
    
    static let identifier = "PopularCell"
    
    @IBOutlet weak var gifImageView: GIFImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    
}
