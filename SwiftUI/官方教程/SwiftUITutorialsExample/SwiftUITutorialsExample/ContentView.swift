//
//  ContentView.swift
//  SwiftUITutorialsExample
//
//  Created by WENBO on 2020/4/9.
//  Copyright © 2020 WENBO. All rights reserved.
//

import SwiftUI

// MARK: - Section 1
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, SwiftUI")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.green)
            
            HStack {
                Text("Joshua Tree National Park")
                    .font(.subheadline)
                Spacer()
                Text("California")
                    .font(.subheadline)
            }
        }
    .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
