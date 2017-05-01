//
//  BaseViewController.swift
//  GifTV
//
//  Created by Martin Sumera on 22/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var serviceProvider: ServiceProvider {
        return appDelegate.serviceProvider
    }
    
    init(_ nibName: String?) {
        super.init(nibName: nibName, bundle: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(nil)
    }
}
