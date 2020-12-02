//
//  ViewController.swift
//  Combine2
//
//  Created by wenbo on 2020/12/2.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var github_id_entry: UITextField!
    
    var usernameSubscriber: AnyCancellable?
    
    let myBackgroundQueue: DispatchQueue = DispatchQueue(label: "viewControllerBackgroudQueue")
    
    @Published var username: String = ""
    @Published private var githubUserData: [GithubAPIUser] = []
    
    // MARK: - Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        github_id_entry .addTarget(self, action: #selector(githubIdChanged(_:)), for: .editingChanged)
        
        usernameSubscriber = $username
            .throttle(for: 0.5, scheduler: myBackgroundQueue, latest: true)
            .removeDuplicates()
            .print("username pipeline: ")
            .map({ username -> AnyPublisher<[GithubAPIUser], Never> in
                return GithubAPI.retrieveGuthubUser(username: username)
            })
            .switchToLatest()
            .receive(on: RunLoop.main)
            .assign(to: \.githubUserData, on: self)
    }

     @objc func githubIdChanged(_ sender: UITextField) {
        username = sender.text ?? ""
        print("set username to ", username)
    }
    
}

