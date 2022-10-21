//
//  SDWebImageSwiftUITest.swift
//  WBAnimatedSwiftUIViewDemo
//
//  Created by wenbo22 on 2022/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SDWebImageSwiftUITest: View {
    @State var isAnimating: Bool = true
    
    var body: some View {
        ScrollView {
            VStack {
                WebImage(url: URL(string: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic"))
                    .onSuccess {_,_,_ in
                        print("success")
                    }
                    .resizable()
                    .placeholder(Image(systemName: "photo"))
                    .placeholder {
                        Rectangle()
                            .foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 300, height: 300, alignment: .center)
                
                WebImage(url: URL(string: "https://raw.githubusercontent.com/liyong03/YLGIFImage/master/YLGIFImageDemo/YLGIFImageDemo/joy.gif"), isAnimating: $isAnimating)
                    .customLoopCount(1)
                    .playbackRate(2.0)
                    .playbackMode(.bounce)
                
                AnimatedImage(url: URL(string: "https://raw.githubusercontent.com/liyong03/YLGIFImage/master/YLGIFImageDemo/YLGIFImageDemo/joy.gif"))
                // Supports options and context, like `.progressiveLoad` for progressive animation loading
                    .onFailure { error in
                        // Error
                    }
                    .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                    .placeholder(UIImage(systemName: "photo")) // Placeholder Image
                // Supports ViewBuilder as well
                    .placeholder {
                        Circle().foregroundColor(.gray)
                    }
                    .indicator(SDWebImageActivityIndicator.medium) // Activity Indicator
                    .transition(.fade) // Fade Transition
                    .scaledToFit() // Attention to call it on AnimatedImage, but not `some View` after View Modifier (Swift Protocol Extension method is static dispatched)
            }
        }
    }
}

struct SDWebImageSwiftUITest_Previews: PreviewProvider {
    static var previews: some View {
        SDWebImageSwiftUITest()
    }
}
