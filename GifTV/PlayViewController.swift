//
//  PlayViewController.swift
//  GifTV
//
//  Created by Martin Sumera on 25/04/2017.
//  Copyright © 2017 Martin Sumera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import ReactorKit
import Gifu
import Foundation
import AVFoundation

class PlayViewController : BaseViewController, ReactorKit.View {
    
    @IBOutlet var viewContainer: UIView!
    
    @IBOutlet weak var loadingTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loadingBottomContraint: NSLayoutConstraint!

    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loadingImage: UIImageView!
    
    @IBOutlet weak var gifImage: GIFImageView!
    
    @IBOutlet weak var gifView: UIView!
    
    @IBOutlet weak var navBar: UINavigationBar!

    @IBOutlet weak var navItem: UINavigationItem!
    
    var query: String
    
    var imageChanger: UIImageChanger?
    
    var player = AVAudioPlayer()
    
    init(withQuery query: String) {
        self.query = query
        super.init("Play")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageChanger = UIImageChanger(forImage: self.loadingImage, withImages: [
            UIImage(named: "loading_1")!,
            UIImage(named: "loading_2")!,
            UIImage(named: "loading_3")!,
            UIImage(named: "loading_2")!
        ])
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(back))

        self.navItem.leftBarButtonItem = backButton
        
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        self.navBar.shadowImage = UIImage()
        self.navBar.isTranslucent = true
        self.navBar.backgroundColor = .clear
        
        self.gifView.isUserInteractionEnabled = true
        
        self.showLoading(withAnimation: false)
        
        self.reactor = PlayReactor(provider: serviceProvider, forQuery: self.query)
    }
    
    func bind(reactor: PlayReactor) {
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: { isLoading in
                if isLoading {
                    self.showLoading(withAnimation: true)
                } else {
                    self.hideLoading()
                }
            })
            .addDisposableTo(self.disposeBag)
        
        reactor.state
            .filter { !$0.isLoading && $0.gifTrack != nil }
            .map { PlayReactor.Action.onGifLoaded($0.gifTrack!) }
            .bind(to: reactor.action)
            .addDisposableTo(self.disposeBag)
        
        reactor.state
            .filter { !$0.isLoading && $0.gifTrack != nil }
            .subscribe(onNext: { state in
                self.playGif(fromPath: state.gifTrack!.gif.path)
                self.playAudio(fromPath: state.gifTrack!.track.path)
            }).addDisposableTo(self.disposeBag)
        
        self.gifView.rx.tapGesture()
            .when(.ended)
            .map { _ in .onGifClicked }
            .bind(to: reactor.action)
            .addDisposableTo(self.disposeBag)
        
        self.rx.viewWillDisappear
            .subscribe(onNext: { [weak self] _ in
                self?.imageChanger!.stop()
                self?.gifImage.stopAnimatingGIF()
                self?.player.stop()
            }).addDisposableTo(self.disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in .onViewWillAppear }
            .bind(to: reactor.action)
            .addDisposableTo(self.disposeBag)
        
        self.rx.viewWillDisappear
            .map { _ in .onViewWillDisappear }
            .bind(to: reactor.action)
            .addDisposableTo(self.disposeBag)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if self.gifImage.frame.width > self.gifImage.frame.height {
            self.gifImage.contentMode = UIViewContentMode.scaleAspectFit
        } else {
            self.gifImage.contentMode = UIViewContentMode.scaleAspectFill
        }
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showLoading(withAnimation animation: Bool) {
        imageChanger!.animate(withDelay: 0.4)
        
        if animation {
            self.view.layoutIfNeeded()
            self.loadingTopConstraint.constant = self.view.frame.height
            self.loadingBottomContraint.constant =  -self.view.frame.height
            UIView.animate(withDuration: 0.4, animations: {
                self.loadingTopConstraint.constant -= self.view.frame.height
                self.loadingBottomContraint.constant += self.view.frame.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func hideLoading() {
        imageChanger!.stop()
        
        self.view.layoutIfNeeded()
        self.loadingTopConstraint.constant = 0
        self.loadingBottomContraint.constant = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.loadingTopConstraint.constant += self.view.frame.height
            self.loadingBottomContraint.constant -= self.view.frame.height
            self.view.layoutIfNeeded()
        })
    }
    
    private func playGif(fromPath gifLocalPath: String) {
        guard FileManager.default.fileExists(atPath: gifLocalPath) else {
            print("Local gif file do not exists")
            return
        }
        
        let url = URL(string: "file://" + gifLocalPath)!
        do {
            let data = try Data.init(contentsOf: url, options: [])
            self.gifImage.animate(withGIFData: data)
        } catch {
            print(error)
        }
    }
    
    private func playAudio(fromPath audioLocalPath: String) {
        guard FileManager.default.fileExists(atPath: audioLocalPath) else {
            print("Local audio file do not exists")
            return
        }
        
        do {
            let url = URL(string: "file://" + audioLocalPath)!
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player.prepareToPlay()
            self.player.volume = 1.0
            self.player.play()
        } catch let error as NSError {
            print(error)
        }
    }
}
