//
//  ContentView.swift
//  WBVisualEffectViewDemo
//
//  Created by wenbo22 on 2022/10/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .background(WBVisualEffectView(effect: .systemMaterialLight))
        .padding()
    }
}

struct WBVisualEffectView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        let effect = UIBlurEffect(style: effect)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(effectView, at: 0)
        
        NSLayoutConstraint.activate([
            effectView.widthAnchor.constraint(equalTo: view.widthAnchor),
            effectView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
