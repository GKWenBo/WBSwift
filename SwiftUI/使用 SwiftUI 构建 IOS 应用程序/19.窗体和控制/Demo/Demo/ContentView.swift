//
//  ContentView.swift
//  Demo
//
//  Created by WENBO on 2022/7/2.
//

import SwiftUI

struct ContentView: View {
    @State var receive = false
    @State var number = 1
    @State var selection = 1
    @State var date = Date()
    @State var email = ""
    @State var submit = false
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $receive) {
                    Text("Receive notifications")
                }
                Stepper(value: $number) {
                    Text("\(number) Notification\(number > 1 ? "s" : "") per week")
                }
                Picker(selection: $selection) {
                    Text("SwiftUI").tag(1)
                    Text("React").tag(2)
                } label: {
                    Text("Favorite course")
                }
                DatePicker(selection: $date) {
                    Text("Date")
                }
                
                Section(header: Text("Email")) {
                    TextField("Your email", text: $email)
                        .textFieldStyle(.roundedBorder)
                }
                Button {
                    submit.toggle()
                } label: {
                    Text("Submit")
                }
                .alert("Thanks!", isPresented: $submit, actions: {
                    
                }, message: {
                    Text("Email: \(email)")
                })

            }
        }
        .navigationTitle("Settings")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
