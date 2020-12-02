//
//  ContentView.swift
//  Calculator
//
//  Created by WENBO on 2020/9/20.
//  Copyright © 2020 WENBO. All rights reserved.
//

import SwiftUI

/// one
//struct ContentView: View {
//    var body: some View {
//        /// HStack
//        HStack {
//            /// 1
//            CalculatorButton(title: "1",
//                             size: CGSize(width: 88, height: 88),
//                             backgroudColorName: "operatorBackground") {
//
//            }
//
//            /// 2
//            CalculatorButton(title: "2",
//                             size: CGSize(width: 88, height: 88),
//                             backgroudColorName: "operatorBackground") {
//
//            }
//
//            CalculatorButton(title: "3",
//                             size: CGSize(width: 88, height: 88),
//                             backgroudColorName: "operatorBackground") {
//
//            }
//
//            CalculatorButton(title: "+",
//                             size: CGSize(width: 88, height: 88),
//                             backgroudColorName: "operatorBackground") {
//                print("+")
//            }
//        }
//    }
//}

/// two
//struct ContentView1: View {
//    let row: [CalculatorButtonItem] = [.digit(1),
//                                       .digit(2),
//                                       .digit(3),
//                                       .op(.plus)]
//    var body: some View {
//        HStack {
//            ForEach(row, id: \.self) { item in
//                CalculatorButton(title: item.title,
//                                 size: item.size,
//                                 backgroudColorName: item.backgroudColor) {
//
//                }
//            }
//        }
//
//    }
//}

/// three
//struct ContentView: View {
//    var body: some View {
//        CalculatorButtonRow(row: [.digit(1), .digit(2), .digit(3), .op(.plus)])
//    }
//}

struct ContentView: View {
    let scale: CGFloat = UIScreen.main.bounds.width / 414
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("0")
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
            CalculatorButtonPad()
                .padding(.bottom)
        }
        .scaleEffect(scale)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
//        ContentView1()
        Group {
            ContentView()
            ContentView().previewDevice("iPhone SE (2nd generation)")
        }
        
    }
}

/// “Button 提取为一个新的 View，把它重命名为 CalculatorButton”
struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroudColorName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color(backgroudColorName))
                .cornerRadius(size.height / 2)
                
        })
    }
}

/// “布局计算和调整”
struct CalculatorButtonRow: View {
    let row: [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(row, id: \.self, content: { item in
                CalculatorButton(title: item.title,
                                 size: item.size,
                                 backgroudColorName: item.backgroudColor) {
                    print("Button: \(item.title)")
                }
            })
        }
    }
}

struct CalculatorButtonPad: View {
    let pad:  [[CalculatorButtonItem]] = [
    [.command(.clear), .command(.flip),
    .command(.percent), .op(.divide)],
    [.digit(7), .digit(8), .digit(9), .op(.multiply)],
    [.digit(4), .digit(5), .digit(6), .op(.minus)],
    [.digit(1), .digit(2), .digit(3), .op(.plus)],
    [.digit(0), .dot, .op(.equal)]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id: \.self, content: { row in
                CalculatorButtonRow(row: row)
            })
        }
    }
}

/// “计算器按钮 Model”
enum CalculatorButtonItem {
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "x"
        case equal = "="
    }
    
    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }
    
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}

extension CalculatorButtonItem: Hashable {
    var title: String {
        switch self {
        case .digit(let value):
            return String(value)
        case .dot:
            return "."
        case .op(let op):
            return op.rawValue
        case .command(let command):
            return command.rawValue
        }
    }
    
    var size: CGSize {
        if case .digit(let value) = self, value == 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
        return CGSize(width: 88, height: 88)
    }
    
    var backgroudColor: String {
        switch self {
        case .digit, .dot:
            return "digitBackground"
        case .op:
            return "operatorBackground"
        case .command:
            return "commandBackground"
        }
    }
    
}
