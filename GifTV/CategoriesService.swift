//
//  CategoriesService.swift
//  GifTV
//
//  Created by Martin Sumera on 22/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import RxSwift

protocol CategoriesServiceType {
    
    func fetchCategories() -> Observable<[Category]>
}

final class CategoriesService: BaseService, CategoriesServiceType {
    
    func fetchCategories() -> Observable<[Category]> {
        let categories = [
            Category("Party"),
            Category("Cat"),
            Category("Dog"),
            Category("Fail"),
            Category("Funny"),
            Category("Kids"),
            Category("Sport"),
            Category("Animals"),
            Category("Thuglife"),
            Category("Memes"),
            Category("Prank"),
            Category("Goat"),
            Category("Fire"),
            Category("Lucky"),
            Category("Dancing"),
            Category("Cute"),
            Category("Slap"),
            Category("Cops"),
            Category("Disco"),
            Category("Metal"),
            Category("Dumb"),
            Category("Legend"),
            Category("Lazy"),
            Category("Movies"),
            Category("Music"),
            Category("Dancing"),
            Category("Science"),
            Category("Rock"),
            Category("Game"),
            Category("Sheep"),
            Category("Versus"),
            Category("Boring"),
            Category("Speed")
        ]
        
        return Observable.just(categories)
    }
}
