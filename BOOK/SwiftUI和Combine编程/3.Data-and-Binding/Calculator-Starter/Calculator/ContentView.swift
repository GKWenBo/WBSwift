//
//  ContentView.swift
//  Calculator
//
//  Created by Wang Wei on 2019/06/17.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import Combine

let scale = UIScreen.main.bounds.width / 414

struct ContentView : View {
//    @State private var brain: CalculatorBrain = .left("0")
    @ObservedObject var model = CalculatorModel()
    
    @State private var editingHistory = false
    
    @State private var showingResult = false
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button("操作履历:\(model.history.count)") {
                print(model.history)
                editingHistory = true
            }
            .sheet(isPresented: $editingHistory) {
                HistoryView(model: model)
            }
            
            Text(model.brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24 * scale)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .trailing)
                .onTapGesture {
                    showingResult = true
                }
                .alert(isPresented: $showingResult) {
                    Alert(title: Text(model.brain.output), primaryButton: .default(Text("Copy"), action: {
                        print("copy")
                    }), secondaryButton: .cancel())
                }
            CalculatorButtonPad(model: model)
                .padding(.bottom)
        }
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView().previewDevice("iPhone SE")
            ContentView().previewDevice("iPad Air 2")
        }
    }
}

struct CalculatorButton : View {

    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let foregroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize * scale))
                .foregroundColor(foregroundColor)
                .frame(width: size.width * scale, height: size.height * scale)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width * scale / 2)
        }
    }
}

struct CalculatorButtonRow : View {
    let row: [CalculatorButtonItem]
//    @Binding var brain: CalculatorBrain
    
    var model: CalculatorModel
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName,
                    foregroundColor: item.foregroundColor)
                {
                    print("Button: \(item.title)")
//                    self.brain = self.brain.apply(item: item)
                    self.model.apply(item)
                }
            }
        }
    }
}

struct CalculatorButtonPad: View {
//    @Binding var brain: CalculatorBrain
    
    var model: CalculatorModel
    
    let pad: [[CalculatorButtonItem]] = [
        [.command(.clear), .command(.flip),
         .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id: \.self) { row in
                CalculatorButtonRow(row: row, model: model)
            }
        }
    }
}
