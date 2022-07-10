//
//  ContentView.swift
//  13.13.13.导航视图和列表
//
//  Created by WENBO on 2022/7/2.
//

import SwiftUI

struct UpdateList: View {
    var body: some View {
        NavigationView {
            NavigationLink {
                Text("Title")
            } label: {
                List(0..<20) { item in
                    NavigationLink {
                        Text("Title")
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Navigate 1")
                                .font(.headline)
                            Text("subtitle")
                                .lineLimit(2)
                                .lineSpacing(4)
                                .font(.subheadline)
                                .frame(height: 50)
                            Text("Date()")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle(Text("Updates"))
            .navigationBarItems(trailing: NavigationLink(destination: {
                Text("Settings")
            }, label: {
                Image(systemName: "gear")
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateList()
    }
}
