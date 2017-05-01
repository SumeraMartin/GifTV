//
//  SelectCategoryReactor.swift
//  GifTV
//
//  Created by Martin Sumera on 22/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import ReactorKit
import RxSwift

class SelectCategoryReactor: BaseReactor {

    let provider: ServiceProviderType
    let initialState: State
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(
            categories: []
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .load:
                return self.provider.categoriesService
                    .fetchCategories()
                    .map { .setCategories($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            case let .setCategories(categories):
                state.categories = categories
                return state
        }
    }
}

extension SelectCategoryReactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setCategories([Category])
    }
    
    struct State {
        var categories: [Category]
    }
}
