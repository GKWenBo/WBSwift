//
//  ViewController.swift
//  Combine3
//
//  Created by wenbo on 2020/12/2.
//

// MARK: - Cascading multiple UI updates, including a network request

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var github_id_entry: UITextField!
    @IBOutlet weak var repositoryCountLabel: UILabel!
    @IBOutlet weak var githubAvatarImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var repositoryCountSubscriber: AnyCancellable?
    var avatarImageViewSubscriber: AnyCancellable?
    var usernameSubscriber: AnyCancellable?
    var headerSubscriber: AnyCancellable?
    var apiNetworkActivitySubscriber: AnyCancellable?
    
    @Published var username: String = ""
    @Published private var githubUserdata: [GithubAPIUser] = []
    
    var myBackgroundQueue: DispatchQueue = DispatchQueue(label: "queue")
    let coreLoactionProxy = LocationHeadingProxy()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bindViewModel()
    }
    
    func bindViewModel()  {
        let apiActivitySub = GithubAPI.networkActivityPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { doingSomethingNow in
                if doingSomethingNow {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            })
        apiNetworkActivitySubscriber = apiActivitySub
        
        usernameSubscriber = $username
            .throttle(for: 0.5, scheduler: myBackgroundQueue, latest: true)
            .removeDuplicates()
            .print("username pipeline: ")
            .map({ username -> AnyPublisher<[GithubAPIUser], Never> in
                return GithubAPI.retrieveGuthubUser(username: username)
            })
            .switchToLatest()
            .receive(on: RunLoop.main)
            .assign(to: \.githubUserdata, on: self)
        
        // using .assign() on the other hand (which returns an
        // AnyCancellable) *DOES* require a Failure type of <Never>
        repositoryCountSubscriber = $githubUserdata
            .print("github user data: ")
            .map { userData -> String in
                if let firstUser = userData.first {
                    return String(firstUser.public_repos)
                }
                return "unknown"
            }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: repositoryCountLabel)
        
        let avatarViewSub = $githubUserdata
            .map({ userData -> AnyPublisher<UIImage, Never> in
                guard let firstUser = userData.first else {
                    return Just(UIImage()).eraseToAnyPublisher()
                }
                return URLSession.shared.dataTaskPublisher(for: URL(string: firstUser.avatar_url)!)
                    .handleEvents { (_) in
                        DispatchQueue.main.async {
                            self.activityIndicator.startAnimating()
                        }
                        
                    }  receiveCompletion: { (_) in
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        }
                    } receiveCancel: {
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        }
                    }
                    .receive(on: self.myBackgroundQueue)
                    .map({ $0.data })
                    .map({ UIImage(data: $0)! })
                    .catch({ error in
                        return Just(UIImage())
                    })
                    .eraseToAnyPublisher()
            })
            .switchToLatest()
            .receive(on: RunLoop.main)
            .map({ image -> UIImage? in
                image
            })
            .assign(to: \.image, on: self.githubAvatarImageView)
        avatarImageViewSubscriber = avatarViewSub
        
        // KVO publisher of UIKit interface element
        let _ = repositoryCountLabel.publisher(for: \.text)
            .sink { (someValue) in
                print("repositoryCountLabel update to \(String(describing: someValue))")
            }
    }

    // MARK: - Event Response
    @IBAction func githubIdChanged(_ sender: UITextField) {
        username = sender.text ?? ""
                print("Set username to ", username)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = FormViewController()
        self.present(vc, animated: true, completion: nil)
    }
    

}

