//
//  AnimatedWidgetModel.swift
//  MyWidgetExtension
//
//  Created by wenbo22 on 2022/11/2.
//

import Foundation
import UIKit

class AnimatedWidgetModel {
    static let `default` = AnimatedWidgetModel()
    
    var image: UIImage? {
        defer {
            index += 1
        }
        
        guard let animatedImages = animatedImages else {
            return nil
        }
        
        guard !animatedImages.images.isEmpty else {
            return nil
        }
        
        if index < animatedImages.images.count {
            return animatedImages.images[index]
        } else {
            index = 0
            return animatedImages.images[index]
        }
    }
    
    private var index = 0
    
    let animatedImages: WBAnimatedImage?
    
    init() {
        let gifData: Data
        do {
            let path = Bundle.main.path(forAuxiliaryExecutable: "test.gif")
            let url = URL(fileURLWithPath: path!)
            
            gifData = try! Data(contentsOf: url)
        } catch {
            print(error)
        }
        
        animatedImages = WBAnimatedImage(gifData)
    }
}
