//
//  FLAnimatedImageTest.swift
//  WBAnimatedSwiftUIViewDemo
//
//  Created by WENBO on 2022/10/20.
//

/*
 FLAnimatedImage加载GIF图片 demo
 */

import SwiftUI
import FLAnimatedImage

struct FLGIFView: UIViewRepresentable {
    let animatedView = FLAnimatedImageView()
    var fileName: String
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let path = Bundle.main.path(forAuxiliaryExecutable: fileName)!
        let url = URL(fileURLWithPath: path)
        
        let data = try! Data(contentsOf: url)
        let gifImage = FLAnimatedImage(animatedGIFData: data)
        
        animatedView.animatedImage = gifImage
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animatedView)
        
        NSLayoutConstraint.activate([
            animatedView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            animatedView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct FLAnimatedImageTest: View {
    var body: some View {
        FLGIFView(fileName: "test.gif")
            .frame(width: 200, height: 200)
        
    }
}

struct FLAnimatedImageTest_Previews: PreviewProvider {
    static var previews: some View {
        FLAnimatedImageTest()
    }
}
