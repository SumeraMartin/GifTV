//
//  HistoryReactor.swift
//  GifTV
//
//  Created by Martin Sumera on 01/05/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import ReactorKit
import RxSwift

class HistoryReactor: BaseReactor {

    let provider: ServiceProviderType
    let initialState: State
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(historyGifTracks: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .viewWillAppear:
                return self.provider.historyService.getAll().map { .showHistory($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            case let .showHistory(historyGifTracks):
                state.historyGifTracks = historyGifTracks
                break
        }
        return state
    }
}

extension HistoryReactor {
    
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case showHistory([HistoryGifTrack])
    }
    
    struct State {
        var historyGifTracks: [HistoryGifTrack]
    }
}
