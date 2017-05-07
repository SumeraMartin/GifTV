//
//  PopularReactor.swift
//  GifTV
//
//  Created by Martin Sumera on 06/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import ReactorKit
import RxSwift

class PopularReactor: BaseReactor {
    
    let provider: ServiceProviderType
    let initialState: State
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(popularGifTracks: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return self.provider.popularService.getAll().map { .showPopular($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            case let .showPopular(popularGifTracks):
                state.popularGifTracks = popularGifTracks
                break
            }
        return state
    }
}

extension PopularReactor {
    
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case showPopular([PopularGifTrack])
    }
    
    struct State {
        var popularGifTracks: [PopularGifTrack]
    }
}
