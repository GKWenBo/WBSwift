//
//  ContentView.swift
//  Calculator
//
//  Created by WENBO on 2020/9/20.
//  Copyright © 2020 WENBO. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button(action: {
            print("Button: +")
        }) {
            Text("+")
            .font(.system(size: 38))
            .foregroundColor(.white)
            .frame(width: 88, height: 88)
            .background(Color.orange)
            .cornerRadius(44)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
