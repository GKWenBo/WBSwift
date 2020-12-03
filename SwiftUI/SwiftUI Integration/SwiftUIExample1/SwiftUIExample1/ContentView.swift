//
//  ContentView.swift
//  SwiftUIExample1
//
//  Created by wenbo on 2020/12/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ReativeForm: View {
    
    @ObservedObject var model: ReactiveFormModel
    @State private var buttonIsDisabled = true
    
    var body: some View {
        
        VStack {
            Text("Reactive Form")
                .font(.headline)
            
            /// Form
            Form {
                TextField("first entry", text: $model.firstEntry)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .padding()
                
                TextField("second entry", text: $model.secondEntry)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack {
                    ForEach(model.validatonMessages, id: \.self, content: { msg in
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.callout)
                    })
                }
                
            }
            
            /// Button
            Button(action: {
                
            }, label: {
                Text("Submit")
            })
            .disabled(buttonIsDisabled)
            .onReceive(model.submitAllowed, perform: { submitAllowed in
                self.buttonIsDisabled = !submitAllowed
            })
            .padding()
            .background(RoundedRectangle(cornerRadius: 10))
            
            /// Spacer
            Spacer()
        }
    }
}

var localModel = ReactiveFormModel()
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReativeForm(model: localModel)
            .previewDevice("iPhone 12 Pro Max")
    }
}
