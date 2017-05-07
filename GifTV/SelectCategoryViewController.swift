//
//  SelectCategoryViewController.swift
//  GifTV
//
//  Created by Martin Sumera on 22/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

typealias CategorySectionModel = SectionModel<Void, Category>

class SelectCategoryViewController : BaseViewController, View {
    
    @IBOutlet weak var savedButton: UIButton!
    
    @IBOutlet weak var historyButton: UIButton!
    
    @IBOutlet weak var trendingButton: UIButton!
    
    @IBOutlet weak var randomButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<CategorySectionModel>()
    
    init() {
        super.init("SelectCategory")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: SelectCategoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: SelectCategoryCell.identifier)
        
        self.reactor = SelectCategoryReactor(provider: serviceProvider)
    }
    
    func bind(reactor: SelectCategoryReactor) {
        self.collectionView.rx
            .setDelegate(self)
            .addDisposableTo(self.disposeBag)
        
        self.dataSource.configureCell = { _, collectionView, indexPath, category in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCategoryCell.identifier, for: indexPath) as! SelectCategoryCell
            cell.text.text = category.title.uppercased()
            cell.text.isUserInteractionEnabled = true
            return cell
        }
        
        reactor.state
            .map { [CategorySectionModel(model: Void(), items: $0.categories)] }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .addDisposableTo(self.disposeBag)
        
        savedButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToSaved()
            })
            .addDisposableTo(self.disposeBag)
        
        historyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToHistory()
            })
            .addDisposableTo(self.disposeBag)
        
        trendingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToCategory(Category.trending())
            })
            .addDisposableTo(self.disposeBag)
        
        randomButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToCategory(Category.random())
            })
            .addDisposableTo(self.disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if let cell = self?.collectionView.cellForItem(at: indexPath) as? SelectCategoryCell {
                    cell.text.animateClick(backgroundColor: UIColor.white, withDuration: 0.2)
                }
            })
            .addDisposableTo(self.disposeBag)
        
        collectionView.rx.modelSelected(type(of: self.dataSource).Section.Item.self)
            .subscribe(onNext: { [weak self] category in
                self?.navigateToCategory(category)
            })
            .addDisposableTo(self.disposeBag)
        
        Observable.just()
            .map { .load }
            .bind(to: reactor.action)
            .addDisposableTo(self.disposeBag)
    }
    
    func navigateToCategory(_ category: Category) {
        let viewController = PlayViewController(withQuery: category.searchValue)
        self.present(viewController, animated: true, completion: nil)
    }
    
    func navigateToSaved() {
        let viewController = PopularViewController()
        self.present(viewController, animated: true, completion: nil)
    }
    
    func navigateToHistory() {
        let viewController = HistoryViewController()
        self.present(viewController, animated: true, completion: nil)
    }
}

extension SelectCategoryViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 10, height: 50)
    }
}
