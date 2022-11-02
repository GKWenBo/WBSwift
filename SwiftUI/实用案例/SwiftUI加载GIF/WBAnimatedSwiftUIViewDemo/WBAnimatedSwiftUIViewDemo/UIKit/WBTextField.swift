//
//  WBTextField.swift
//  WBAnimatedSwiftUIViewDemo
//
//  Created by wenbo22 on 2022/10/20.
//

import SwiftUI

class WrappableTextField: UITextField, UITextFieldDelegate {
    var textFieldChangedHandler: ((String)->Void)?
    var onCommitHandler: (()->Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentValue = textField.text as NSString? {
            let proposedValue = currentValue.replacingCharacters(in: range, with: string)
            textFieldChangedHandler?(proposedValue as String)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onCommitHandler?()
    }
}

struct WBTextField: UIViewRepresentable {
    private let tmpView = WrappableTextField()
    
    var tag: Int = 0
    var placeholder: String?
    var changeHandler: ((String) -> Void)?
    var onCommitHandler: (() -> Void)?
    
    func makeUIView(context: Context) -> some UIView {
        tmpView.tag = tag
        tmpView.delegate = tmpView
        tmpView.placeholder = placeholder
        tmpView.onCommitHandler = onCommitHandler
        tmpView.textFieldChangedHandler = changeHandler
        return tmpView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

struct TextFieldContentView : View {
    @State var username:String = ""
    @State var email:String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(username)
                Spacer()
                Text(email)
            }
            WBTextField(tag: 0, placeholder: "@username", changeHandler: { (newString) in
                self.username = newString
            }, onCommitHandler: {
                print("commitHandler")
            }).padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)).background(Color.red)
            WBTextField(tag: 1, placeholder: "@email", changeHandler: { (newString) in
                self.email = newString
            }, onCommitHandler: {
                print("commitHandler")
            }).padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)).background(Color.red)
        }
    }
}

struct WBTextField_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldContentView()
    }
}
