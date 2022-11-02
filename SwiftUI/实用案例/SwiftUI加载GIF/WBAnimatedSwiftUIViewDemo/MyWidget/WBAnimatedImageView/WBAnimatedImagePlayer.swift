//
//  WBAnimatedImagePlayer.swift
//  WBAnimatedSwiftUIViewDemo
//
//  Created by wenbo22 on 2022/10/21.
//

import Foundation
import ImageIO
import UIKit
import CoreServices

class WBAnimatedImagePlayer {
    deinit {
        if displayLinkInitialized {
            displayLink.invalidate()
        }
    }
    
    var updateFrameBlock: ((UIImage?) -> Void)?
    
    /// displayLink 为懒加载 避免还没有加载好的时候使用了 造成异常
    private var displayLinkInitialized: Bool = false
        
    var repeatCount = 0
    
    var autoPlayAnimatedImage = true
    
    /// Animator 对象
    private var animator: WBAnimator?
    
    var gifFilePath: String? {
        didSet {
            let data = Self.loadLocalGIF(from: gifFilePath)
            gifData = data
        }
    }
    
    var gifData: Data? {
        didSet {
            if let gifData = gifData {
                guard let imageSource = WBAnimator.createImageSource(data: gifData) else {
                    return
                }
                
                animator = nil;
                animator = WBAnimator(maxFrameCount: 100,
                                      imageSource: imageSource,
                                      maxRepeatCount: repeatCount,
                                      preloadQueue: preloadQueue)
                animator?.prepareFramesAsynchronously()
                
                startAnimating()
            }
        }
    }
        
    /// 是否正在动画
    var isAnimating: Bool {
        if displayLinkInitialized {
            return !displayLink.isPaused
        }
        return false
    }
    
    private lazy var displayLink: CADisplayLink = {
        displayLinkInitialized = true
        let displayLink = CADisplayLink(target: WBTargetProxy(target: self), selector: #selector(WBTargetProxy.onScreenUpdate))
        displayLink.add(to: .main, forMode: runLoopMode)
        displayLink.isPaused = false
        return displayLink
    }()
    
    /// 队列
    private lazy var preloadQueue: DispatchQueue = {
        return DispatchQueue(label: "com.onevcat.Kingfisher.Animator.preloadQueue")
    }()
    
    /// 设置runloop mode
    var runLoopMode = RunLoop.Mode.default {
        willSet {
            guard runLoopMode == newValue else {
                return
            }
            
            stopAnimating()
            displayLink.remove(from: .main, forMode: runLoopMode)
            displayLink.add(to: .main, forMode: newValue)
            startAnimating()
        }
    }
    
    func startAnimating() {
        guard !isAnimating else {
            return
        }
        if animator?.isReachMaxRepeatCount ?? false {
            return
        }
        displayLink.isPaused = false
    }
    
    func stopAnimating() {
        if displayLinkInitialized {
            displayLink.isPaused = true
        }
    }
    
    private func updateFrameIfNeeded() {
        guard let animator = animator else { return }
        
        guard !animator.isFinished else {
            stopAnimating()
            return
        }
        
        let duration: CFTimeInterval
        
        if displayLink.preferredFramesPerSecond == 0 {
            duration = displayLink.duration;
        } else {
            duration = 1.0 / Double(displayLink.preferredFramesPerSecond)
        }
        animator.shouldChangeFrame(with: duration) { [weak self] updateFrame in
            guard let _ = self else {
                return
            }
            
            if let updateFrameBlock = updateFrameBlock {
                updateFrameBlock(animator.currentFrameImage)
            }
        }
    }
    
    static func loadLocalGIF(from path: String?) -> Data? {
        guard path != nil else {
            print("File does not exist")
            return nil
        }
        var gifData = Data()
        do {
            let pathStr = Bundle.main.path(forAuxiliaryExecutable: path!)!
            let url = URL(fileURLWithPath: pathStr)
            gifData = try! Data(contentsOf: url)
        } catch {
            print(error)
        }
        return gifData
    }
}

extension WBAnimatedImagePlayer {
    private class WBTargetProxy {
        private weak var target: WBAnimatedImagePlayer?
        
        init(target: WBAnimatedImagePlayer? = nil) {
            self.target = target
        }
        
        @objc func onScreenUpdate() {
            self.target?.updateFrameIfNeeded()
        }
    }
}

extension WBAnimatedImagePlayer {
    class WBAnimator {
        private let maxFrameCount: Int
        private let imageSource: CGImageSource
        private let maxRepeatCount: Int
        private let maxTimeStep: TimeInterval = 1.0
        private var animatedFrames = [WBAnimatedFrame]()
        private var frameCount = 0
        private var timeSinceLastFrameChange: TimeInterval = 0.0
        private var currentRepeatCount: UInt = 0
        var isFinished: Bool = false
        var loopDuration: TimeInterval = 0.0
        var currentFrameIndex = 0
        var previousFrameIndex = 0
        var contentModel: UIView.ContentMode = .scaleToFill
        
        private lazy var preloadQueue: DispatchQueue = {
            return DispatchQueue(label: "com.onevcat.Kingfisher.Animator.preloadQueue")
        }()
        
        var isLastFrame: Bool {
            return currentFrameIndex == frameCount - 1
        }
        
        var currentFrameImage: UIImage? {
            return frameImage(at: currentFrameIndex)
        }
        
        var currentFrameDuration: TimeInterval {
            return frameDuration(at: currentFrameIndex)
        }
        
        var isReachMaxRepeatCount: Bool {
            if maxRepeatCount == 0 {
                return false
            } else if currentRepeatCount >= maxRepeatCount - 1 {
                return true
            } else {
                return false
            }
        }
        
        // MARK: - init
        init(maxFrameCount: Int,
             imageSource: CGImageSource,
             maxRepeatCount: Int,
             preloadQueue: DispatchQueue) {
            self.maxFrameCount = maxFrameCount
            self.imageSource = imageSource
            self.maxRepeatCount = maxRepeatCount
            self.preloadQueue = preloadQueue
        }
        
        func prepareFramesAsynchronously() {
            frameCount = CGImageSourceGetCount(imageSource)
            animatedFrames.reserveCapacity(frameCount)
            preloadQueue.async { [weak self] in
                self?.setupAnimatedFrames()
            }
        }
        
        func shouldChangeFrame(with duration: CFTimeInterval, handler: (Bool) -> Void) {
            timeSinceLastFrameChange += min(maxTimeStep, duration)
            
            if currentFrameDuration > timeSinceLastFrameChange {
                handler(false)
            } else {
                timeSinceLastFrameChange -= currentFrameDuration
                currentFrameIndex = increment(frameIndex: currentFrameIndex)
                if isLastFrame && isReachMaxRepeatCount {
                    isFinished = true
                } else if currentFrameIndex == 0 {
                    currentRepeatCount += 1
                }
                handler(true)
            }
        }
        
        // MARK: - class method
        static public func createImageSource(data: Data) -> CGImageSource? {
            let info: [String: Any] = [
                kCGImageSourceShouldCache as String: true,
                kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF
            ]
            
            guard let imageSource = CGImageSourceCreateWithData(data as CFData, info as CFDictionary) else {
                print("creat imageSource error")
                return nil
            }
            return imageSource
        }
        
        // Calculates frame duration for a gif frame out of the kCGImagePropertyGIFDictionary dictionary.
        static func getFrameDuration(from gifInfo: [String: Any]?) -> TimeInterval {
            let defaultFrameDuration = 0.1
            guard let gifInfo = gifInfo else { return defaultFrameDuration }
            
            let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
            let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
            let duration = unclampedDelayTime ?? delayTime
            
            guard let frameDuration = duration else { return defaultFrameDuration }
            return frameDuration.doubleValue > 0.011 ? frameDuration.doubleValue : defaultFrameDuration
        }
        
        // Calculates frame duration at a specific index for a gif from an `imageSource`.
        static func getFrameDuration(from imageSource: CGImageSource, at index: Int) -> TimeInterval {
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil)
                as? [String: Any] else { return 0.0 }
            
            let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any]
            return getFrameDuration(from: gifInfo)
        }
        
        // MARK: - private method
        private func setupAnimatedFrames() {
            resetAnimatedFrames()
            
            var duration: TimeInterval = 0
            
            (0..<frameCount).forEach { index in
                let frameDuration = Self.getFrameDuration(from: imageSource, at: index)
                duration += frameDuration
                
                animatedFrames += [WBAnimatedFrame(image: nil, duration: frameDuration)]
                
                if index > maxFrameCount {
                    return
                }
                
                animatedFrames[index] = animatedFrames[index].makeAnimatedFrame(image: loadFrame(at: index))
            }
            
            /// 总时间
            self.loopDuration = duration
        }
        
        /// 加载图片
        private func loadFrame(at index: Int) -> UIImage? {
            guard let image = CGImageSourceCreateImageAtIndex(imageSource, index, nil) else {
                return nil
            }
            return UIImage(cgImage: image)
        }
        
        private func resetAnimatedFrames() {
            animatedFrames = []
        }
        
        private func frameDuration(at index: Int) -> TimeInterval {
            return animatedFrames[safe: index]?.duration ?? .infinity
        }
        
        private func frameImage(at index: Int) -> UIImage? {
            return animatedFrames[safe: index]?.image
        }
        
        private func increment(frameIndex: Int, by value: Int = 1) -> Int {
            return (frameIndex + value) % frameCount
        }
    }
}

extension WBAnimatedImagePlayer {
    struct WBAnimatedFrame {
        var image: UIImage?
        var duration: TimeInterval
        
        func makeEmptyAnimateFrame() -> WBAnimatedFrame {
            return .init(image: nil, duration: 0.0)
        }
        
        func makeAnimatedFrame(image: UIImage?) -> WBAnimatedFrame {
            return .init(image:image, duration: duration)
        }
    }
}


extension Array {
    subscript(safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
}
