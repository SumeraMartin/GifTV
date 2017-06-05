//
//  HistoryViewController.swift
//  GifTV
//
//  Created by Martin Sumera on 01/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

typealias HistorySectionModel = SectionModel<Void, HistoryGifTrack>

class HistoryViewController : BaseViewController, View {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    let dataSource = RxTableViewSectionedReloadDataSource<HistorySectionModel>()

    init() {
        super.init("History")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: HistoryGifTrackCell.identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: HistoryGifTrackCell.identifier)
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(back))
        self.navItem.leftBarButtonItem = backButton
        
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        self.navBar.shadowImage = UIImage()
        self.navBar.isTranslucent = true
        self.navBar.backgroundColor = .clear
        
        self.reactor = HistoryReactor(provider: serviceProvider)
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func bind(reactor: HistoryReactor) {
        dataSource.configureCell = { _, tableView, indexPath, historyGifTrack in
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryGifTrackCell.identifier, for: indexPath) as! HistoryGifTrackCell
            cell.title.text = historyGifTrack.trackArtistName
            cell.subTitle.text = historyGifTrack.trackName
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.gifImageView.animate(fromPath: historyGifTrack.gifLocalPath)
            return cell
        }
        
        reactor.state
            .map { [HistorySectionModel(model: Void(), items: $0.historyGifTracks)] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .addDisposableTo(self.disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in .viewWillAppear }
            .bind(to: reactor.action)
            .addDisposableTo(self.disposeBag)
    }
}

extension HistoryViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
