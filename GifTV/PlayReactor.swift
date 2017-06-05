//
//  PlayReactor.swift
//  GifTV
//
//  Created by Martin Sumera on 25/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import ReactorKit
import RxSwift

class PlayReactor: BaseReactor {

    let provider: ServiceProviderType
    let initialState: State
    let query: String
    
    let actionSubject = PublishSubject<Action>()
    
    init(provider: ServiceProviderType, forQuery query: String) {
        self.provider = provider
        self.query = query
        
        self.initialState = State(
            isError: false,
            isLoading: false,
            isFavorite: false,
            gifTrack: nil
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        actionSubject.onNext(action)
        switch action {
            case .onViewWillAppear:
                return self.getGifTrack(byQuery: self.query)
                    .startWith(.showLoading)
                    .takeUntil(self.actionSubject.filter { $0 == Action.onViewWillDisappear })
                    .catchErrorJustReturn(.showError)
        case let .onGifLoaded(gifTrack):
                self.addToHistory(gifTrack)
                
                let getGif = self.getGifTrack(byQuery: self.query)
                let waitSeveralSeconds = Observable<Int>
                    .interval(8, scheduler: MainScheduler.instance)
                    .take(1)
                
                return Observable.zip(getGif, waitSeveralSeconds)
                    .map { (gif, __) in gif }
                    .takeUntil(self.actionSubject.filter { $0 == Action.onViewWillDisappear })
                    .catchErrorJustReturn(.showError)
            case .onGifClicked:
                return Observable.just(.showLoading)
            case .onViewWillDisappear:
                return Observable.empty()
            case let .onGifMarkedAsFavorite(gifTrack):
                return self.provider.popularService
                    .add(gifTrack)
                    .map { .markAsFavorite }
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            case .showLoading:
                state.isLoading = true
                return state
            case let .showGifTrack(gifTrack):
                state.isFavorite = false
                state.isLoading = false
                state.gifTrack = gifTrack
                return state
            case .markAsFavorite:
                state.isFavorite = true
                return state
            case .showError:
                state.isError = true
            return state
        }
    }
        
    private func getGifTrack(byQuery query: String) -> Observable<Mutation> {
        return self.provider.gifTrackService
            .get(byQuery: query)
            .map { gifTrack in Mutation.showGifTrack(gifTrack) }
    }
    
    private func addToHistory(_ gifTrack: GifTrackSaved) {
        let url = gifTrack.gif.gif.images.fixedWidthThumbnail.url
        let name = gifTrack.gif.gif.id
        self.provider.downloadService
            .download(fromUrl: url, to: .documentDirectory, withName: name)
            .flatMap { _ in
                self.provider.historyService.add(fromGifTrack: gifTrack)
            }
            .subscribe()
    }
}

extension PlayReactor {
    
    enum Action {
        case onViewWillAppear
        case onViewWillDisappear
        case onGifClicked
        case onGifLoaded(GifTrackSaved)
        case onGifMarkedAsFavorite(GifTrackSaved)
    }
    
    enum Mutation {
        case showLoading
        case showGifTrack(GifTrackSaved)
        case markAsFavorite
        case showError
    }
    
    struct State {
        var isError: Bool
        var isLoading: Bool
        var isFavorite: Bool
        var gifTrack: GifTrackSaved?
    }
}

func ==(lhs: PlayReactor.Action, rhs: PlayReactor.Action) -> Bool {
    switch (lhs, rhs) {
        case (.onViewWillAppear, .onViewWillAppear):
            return true
        case (.onViewWillDisappear, .onViewWillDisappear):
            return true
        case (.onGifClicked, .onGifClicked):
            return true
        case (.onGifLoaded(_), .onGifLoaded(_)):
            return true
        default:
            return false
    }
}


