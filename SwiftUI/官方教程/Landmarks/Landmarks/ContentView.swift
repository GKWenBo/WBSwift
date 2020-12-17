//
//  ContentView.swift
//  Landmarks
//
//  Created by WENBO on 2020/12/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            /// MapView
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            /// CircleImage
            CircleImage()
                .offset(x: (UIScreen.main.bounds.width - 15 - 50) / 2 - 25 , y: -50)
                .padding(.bottom, -50)
            
            VStack(alignment:.leading) {
                Text("Turtle Rock")
                    .font(.title)
                    .foregroundColor(.green)
                
                HStack {
                    Text("Joshua Tree National Park")
                        .font(.subheadline)
                    Spacer()
                    Text("California")
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("About Turtle Rock")
                    .font(.title2)
                Text("Descriptive text goes here.")

            }
            .padding()
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 Pro")
        
    }
}
