//
//  LoadingAnimation.swift
//  Keys
//
//  Created by John Jakobsen on 7/30/23.
//

import Foundation
import UIKit
import Lottie

class LoadingAnimation: UIView {
    private let _animationView: LottieAnimationView
    
    public init() {
        _animationView = .init(name: "Animations/Unlocking_Animation")
        super.init(frame: CGRect())
        self._animationView.contentMode = .scaleAspectFit
        self._animationView.loopMode = .loop
        let animationPath = Bundle.main.path(forResource: "Unlocking_Animation", ofType: "json")!
        self._animationView.animation = .filepath(animationPath)
        self.addSubview(_animationView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _animationView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    func setFrame(_ frame: CGRect) {
        self.frame = frame
        layoutSubviews()
    }
    
    public func updateFrame(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        let xNotNil = x ?? self._animationView.frame.minX
        let yNotNil = y ?? self._animationView.frame.minY
        let widthNotNil = width ?? self._animationView.frame.width
        let heightNotNil = height ?? self._animationView.frame.height
        self.frame = CGRect(x: xNotNil, y: yNotNil, width: widthNotNil, height: heightNotNil)
        layoutSubviews()
    }
    
    public func play() {
        _animationView.isHidden = false
        _animationView.play()
    }
    
    public func stop() {
        _animationView.isHidden = true
        _animationView.stop()
    }
    
}
