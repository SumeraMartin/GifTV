//
//  ServiceProvider.swift
//  GifTV
//
//  Created by Martin Sumera on 22/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

protocol ServiceProviderType: class {
    
    var categoriesService: CategoriesService { get }
    
    var giphyService: GiphyService { get }
    
    var spotifyService: SpotifyService { get }
    
    var spotifyTokenService: SpotifyTokenService { get }
    
    var gifTrackService: GifTrackService { get }
    
    var historyService: HistoryService { get }
    
    var popularService: PopularService { get }
    
    var downloadService: DownloadService { get }
}

final class ServiceProvider: ServiceProviderType {
    
    lazy var categoriesService: CategoriesService = CategoriesService(provider: self)
    
    lazy var giphyService: GiphyService = GiphyService(provider: self)
    
    lazy var spotifyService: SpotifyService = SpotifyService(provider: self)
    
    lazy var spotifyTokenService: SpotifyTokenService = SpotifyTokenService(provider: self)
    
    lazy var gifTrackService: GifTrackService = GifTrackService(provider: self)
    
    lazy var historyService: HistoryService = HistoryService(provider: self)
    
    lazy var popularService: PopularService = PopularService(provider: self)
    
    lazy var downloadService: DownloadService = DownloadService(provider: self)
}
