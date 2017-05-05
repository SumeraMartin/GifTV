//
//  HistoryGifTrackCell.swift
//  GifTV
//
//  Created by Martin Sumera on 01/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit
import Gifu

class HistoryGifTrackCell : UITableViewCell {

    static let identifier = "HistoryCell"
    
    @IBOutlet weak var gifImageView: GIFImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
}
