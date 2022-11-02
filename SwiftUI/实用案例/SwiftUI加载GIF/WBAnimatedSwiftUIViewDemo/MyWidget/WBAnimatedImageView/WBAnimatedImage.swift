//
//  WBAnimatedImage.swift
//  WBAnimatedSwiftUIViewDemo
//
//  Created by wenbo22 on 2022/10/21.
//

import Foundation
import UIKit
import ImageIO
import MobileCoreServices

struct WBAnimatedImage {
    let images: [UIImage]
    let duration: TimeInterval
    
    // MARK: - init
    init?(_ data: Data) {
        var girDuration = 0.0
        var tempImages: [UIImage] = []
        let info: [String: Any] = [kCGImageSourceShouldCache as String: true,
                                   kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF]
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, info as CFDictionary) else { return nil }
        
        let frameCount = CGImageSourceGetCount(imageSource)
        if (frameCount == 1) {
            girDuration = .infinity
        }
        for i in 0..<frameCount {
            if let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, info as CFDictionary), let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? [String: Any], let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                
                let defaultFrameDuration = 0.1
                /// 获取该帧图片的播放时间
                let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
                /// 如果通过kCGImagePropertyGIFUnclampedDelayTime没有获取到播放时长，就通过kCGImagePropertyGIFDelayTime来获取，两者的含义是相同的
                let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
                
                let duration = unclampedDelayTime ?? delayTime
                
                if let duration = duration {
                    /// 对于播放时间低于0.011s的,重新指定时长为0.100s
                    let gifFrameDuration = duration.doubleValue > 0.011 ? duration.doubleValue : defaultFrameDuration
                    
                    /// 计算总时间
                    girDuration += gifFrameDuration
                    
                    /// 图片
                    let frameImage = UIImage(cgImage: imageRef)
                    tempImages.append(frameImage)
                }
            }
        }
        
        self.duration = girDuration
        self.images = tempImages
    }
}
