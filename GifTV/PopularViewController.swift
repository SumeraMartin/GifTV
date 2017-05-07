//
//  PopularViewController.swift
//  GifTV
//
//  Created by Martin Sumera on 06/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

typealias PopularSectionModel = SectionModel<Void, PopularGifTrack>

class PopularViewController : BaseViewController, View {
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    let dataSource = RxTableViewSectionedReloadDataSource<PopularSectionModel>()
    
    init() {
        super.init("Popular")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: PopularGifTrackCell.identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: PopularGifTrackCell.identifier)
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(back))
        self.navItem.leftBarButtonItem = backButton
        
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        self.navBar.shadowImage = UIImage()
        self.navBar.isTranslucent = true
        self.navBar.backgroundColor = .clear
        
        self.reactor = PopularReactor(provider: serviceProvider)
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func bind(reactor: PopularReactor) {
        dataSource.configureCell = { _, tableView, indexPath, popularGifTrack in
            let cell = tableView.dequeueReusableCell(withIdentifier: PopularGifTrackCell.identifier, for: indexPath) as! PopularGifTrackCell
            cell.title.text = popularGifTrack.trackArtistName
            cell.subtitle.text = popularGifTrack.trackName
            cell.gifImageView.animate(fromPath: popularGifTrack.gifLocalPath)
            return cell
        }
        
        reactor.state
            .map { [PopularSectionModel(model: Void(), items: $0.popularGifTracks)] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .addDisposableTo(self.disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in .viewWillAppear }
            .bind(to: reactor.action)
            .addDisposableTo(self.disposeBag)
    }
}

extension PopularViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
