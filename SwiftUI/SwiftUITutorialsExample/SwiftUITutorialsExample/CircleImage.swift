//
//  CircleImage.swift
//  SwiftUITutorialsExample
//
//  Created by WENBO on 2020/4/9.
//  Copyright © 2020 WENBO. All rights reserved.
//

import SwiftUI

// MARK: - Section 4
/// Create a Custom Image View

struct CircleImage: View {
    var body: some View {
        Image("timg")
            .clipShape(Circle())
            .frame(width: 200, height: 200)
            .aspectRatio(contentMode: .fill)
            .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
            .shadow(radius: 10)
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
