//
//  CustomPlayModel.swift
//  WBAnimatedSwiftUIViewDemo
//
//  Created by wenbo22 on 2022/11/2.
//

import Foundation
import SwiftUI

final class CustomPlayModel: ObservableObject {
    @Published var image: UIImage = UIImage()
    
    let player = WBAnimatedImagePlayer()
    
    init() {
        player.updateFrameBlock = { [weak self] image in
            guard let image = image else {
                return
            }
            self?.image = image
        }
        player.gifFilePath = "test.gif"
        
    }
}
