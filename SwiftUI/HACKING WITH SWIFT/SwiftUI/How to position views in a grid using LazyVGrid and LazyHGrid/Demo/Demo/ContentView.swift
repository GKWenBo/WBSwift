//
//  ContentView.swift
//  Demo
//
//  Created by wenbo on 2022/7/4.
//

import SwiftUI

struct ContentView: View {
    let data = (0...100).map { "item \($0)" }
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(data, id: \.self) { item in
                    Text(item)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 300, alignment: .center)
    }
}

struct ContentView1: View {
    let data = (0...100).map { "item \($0)" }
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(data, id: \.self) { item in
                    Text(item)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 300, alignment: .center)
    }
}

struct ContentView2: View {
    let data = (0...100).map { "item \($0)" }
    let columns = [
        GridItem(.fixed(100)),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(data, id: \.self) { item in
                    Text(item)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 300, alignment: .center)
    }
}

struct ContentView3: View {
    let items = 1...50

    let rows = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .center) {
                ForEach(items, id: \.self) { item in
                    Image(systemName: "\(item).circle.fill")
                        .font(.largeTitle)
                }
            }
            .frame(height: 150)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()
            .previewInterfaceOrientation(.portrait)
    }
}
