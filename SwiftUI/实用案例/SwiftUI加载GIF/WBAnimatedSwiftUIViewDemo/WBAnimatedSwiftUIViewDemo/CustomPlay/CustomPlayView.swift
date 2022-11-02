//
//  CustomPlayView.swift
//  WBAnimatedSwiftUIViewDemo
//
//  Created by wenbo22 on 2022/11/2.
//

import SwiftUI

struct CustomPlayView: View {
    @ObservedObject var model = CustomPlayModel()
    
    var body: some View {
        Image(uiImage: model.image)
    }
}

struct CustomPlayView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPlayView()
    }
}
