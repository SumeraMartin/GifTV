//
//  BaseReactor.swift
//  GifTV
//
//  Created by Martin Sumera on 22/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import ReactorKit
import RxSwift

protocol BaseReactor : Reactor {
    
}

extension BaseReactor {
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action.debug("action")
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation>{
        return mutation.debug("mutation")
    }
    
    func transform(state: Observable<State>) -> Observable<State> {
        return state.debug("state")
    }
}
