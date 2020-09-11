//
//  VideoLauncher.swift
//  youtube
//
//  Created by jungwooram on 2020-06-11.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoPlayerView: YouTubePlayerView, YouTubePlayerDelegate {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    //MARK:
    var handleArea: UIView!
    var visualEffectView: UIVisualEffectView!
    
    let cardHeight: CGFloat = 600
    let cardHandleAreaHeight: CGFloat = 65
    
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    
    lazy var tapGestureView: UIView = {
        let view = UIView()
        let selector = #selector(handleTapGesture)
        let tap = UITapGestureRecognizer(target: self, action: selector)
        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return view
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let activitiIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupVideo()
    }
    
    override func layoutSubviews() {

        super.layoutSubviews()
        
        tapGestureView.frame = frame
        addSubview(tapGestureView)
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activitiIndicatorView)
        activitiIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activitiIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        testLabel.frame = frame
        controlsContainerView.addSubview(testLabel)
        
        bringSubviewToFront(tapGestureView)
    }
    
    private func setupVideo() {
        baseURL = "https://www.youtube.com"
        playerVars["controls"] = "0" as AnyObject
        playerVars["showinfo"] = "0" as AnyObject
        playerVars["rel"] = "0" as AnyObject
        playerVars["playsinline"] = "1" as AnyObject
        delegate = self
        //loadVideoID("e-ORhEE9VVg")
        loadPlaylistID("RDEMb1vAi4rwXXeDlr7NZ68C_w")
    }
    
    @objc func handleTapGesture() {
        print("tap")
        
        if(controlsContainerView.isHidden) {
            controlsContainerView.backgroundColor = .clear
        }else {
            controlsContainerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        }
        controlsContainerView.isHidden = !controlsContainerView.isHidden
        
        seekTo(1, seekAhead: true)
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        play()
    }
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print(playerState)
        switch playerState {
            case .Playing:
                activitiIndicatorView.stopAnimating()
                controlsContainerView.backgroundColor = .clear
            
                getCurrentTime { (time) in
                    print(time!)
                }
                getDuration { (time) in
                    print(time!)
                }
                
            default:
            break
        }
    }
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    
    func showVideoPalyer() {
        
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            
            let view = UIView(frame: window.frame)
            
            view.backgroundColor = .white
            
            view.frame = CGRect(x: window.frame.width - 10, y: window.frame.height - 10, width: 10, height: 10)
            
            //16 * 9 is the aspect ratio of all HD Videos
            let height = window.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            window.addSubview(view)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = window.frame
            }) { (completedAnimation) in
                UIApplication.shared.isStatusBarHidden = true
            }
        }
    }
}
/*
extension VideoPlayerView {
    func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = view.frame
        addSubview(visualEffectView)
        
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardViewController)
        collectionView.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: view.frame.height - cardHandleAreaHeight, width: view.frame.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc
    func handleCardTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
            case .ended:
                animateTransitionIfNeeded(state: nextState, duration: 0.9)
            default:
                break
        }
    }
    
    @objc
    func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .began:
                startInteractiveTransition(state: nextState, duration: 0.9)
            case .changed:
                let translation = recognizer.translation(in: self.cardViewController.handleArea)
                var fractionComplete = translation.y / cardHeight
                fractionComplete = cardVisible ? fractionComplete : -fractionComplete
                updateInteractiveTrasition(fractionComplete: fractionComplete)
            case .ended:
                continueInteractiveTransition()
            default:
                break
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                
                switch state {
                    case .expanded:
                        self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                    case .collapsed:
                        self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                    case .expanded:
                        self.cardViewController.view.layer.cornerRadius = 12
                    case .collapsed:
                        self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                    case .expanded:
                        self.visualEffectView.effect = UIBlurEffect(style: .dark)
                    case .collapsed:
                        self.visualEffectView.effect = nil
                }
            }
            
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            // run animations
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTrasition(fractionComplete: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionComplete + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
*/
