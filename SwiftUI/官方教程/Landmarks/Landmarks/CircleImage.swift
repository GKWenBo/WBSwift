//
//  CircleImage.swift
//  Landmarks
//
//  Created by WENBO on 2020/12/17.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("test")
            .frame(width: 100,
                   height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,
                   alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                        .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
