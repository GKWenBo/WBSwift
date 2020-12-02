//
//  FormViewController.swift
//  Combine3
//
//  Created by wenbo on 2020/12/2.
//

import UIKit
import Combine

class FormViewController: UIViewController {

    @IBOutlet weak var value2_message_label: UILabel!
    @IBOutlet weak var value1_message_label: UILabel!
    @IBOutlet weak var submission_button: UIButton!
    @IBOutlet weak var value2_repeat_input: UITextField!
    @IBOutlet weak var value1_input: UITextField!
    @IBOutlet weak var value2_input: UITextField!
    
    @Published var value1: String = ""
    @Published var value2: String = ""
    @Published var value2_repeat: String = ""
    
    var validatedValue1: AnyPublisher<String?, Never> {
        return $value1.map({ value in
            guard value.count > 2 else {
                DispatchQueue.main.async {
                    self.value1_message_label.text = "minimum of 3 characters required"
                }
                return nil
            }
            DispatchQueue.main.async {
                self.value1_message_label.text = ""
            }
            return value
        })
        .eraseToAnyPublisher()
    }
    
    var validatedValue2: AnyPublisher<String?, Never> {
        return Publishers.CombineLatest($value2, $value2_repeat)
            .receive(on: RunLoop.main)
            .map({ value2, value2_repeat in
                guard value2_repeat == value2, value2.count > 4 else {
                    self.value2_message_label.text = "values must match and have at least 5 characters"
                    return nil
                }
                self.value2_message_label.text = ""
                return value2
            })
            .eraseToAnyPublisher()
    }
    
    var readyToSubmit: AnyPublisher<(String, String)?, Never> {
        return Publishers.CombineLatest(validatedValue2, validatedValue1)
            .map { (value2, value1) in
                guard let realValue2 = value2, let realValue1 = value1 else {
                    return nil
                }
                return (realValue2, realValue1)
            }
            .eraseToAnyPublisher()
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindViewModel()
    }
    
    func bindViewModel() {
        self.readyToSubmit
            .map({ $0 != nil })
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submission_button)
            .store(in: &cancellableSet)
    }
    
    // MARK: - Event Respons
    @IBAction func value1_updated(_ sender: UITextField) {
        value1 = sender.text ?? ""
    }
    
    @IBAction func value2_updated(_ sender: UITextField) {
        value2 = sender.text ?? ""
    }
    
    @IBAction func value2_repeat_updated(_ sender: UITextField) {
        value2_repeat = sender.text ?? ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
