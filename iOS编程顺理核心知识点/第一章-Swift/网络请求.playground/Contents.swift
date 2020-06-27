import UIKit

// MARK: - Protocol
protocol SMURLNetWorking {
    func asURL() -> URL
}

// MARK: - Extension
extension String: SMURLNetWorking {
    public func asURL() -> URL {
        guard let url = URL(string: self) else { return URL(string: "http:www.starming.com")! }
        return url
    }
}

struct SMOP {
    var httpMethod: HTTPMethod
}

enum HTTPMethod: String {
    case GET, POST, PUT
}

// MARK: - SMNetWorking
open class SMNetWorking<T: Codable> {
    public let session: URLSession
    var op: SMOP
    typealias CompletionJSONClosure = (_ data: T) -> Void
    var completionJSONClosure: CompletionJSONClosure = {_ in}
    
    public init() {
        self.session = URLSession.shared
        self.op = SMOP(httpMethod: .GET)
    }
    
    /// JSON请求
    func requestJSON(url: SMURLNetWorking,
                     doneClosure: @escaping CompletionJSONClosure) -> Void {
        self.completionJSONClosure = doneClosure
        let request: URLRequest = NSURLRequest.init(url: url.asURL()) as URLRequest
        let task = self.session.dataTask(with: request) { (data, res, error) in
            if error == nil {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(T.self, from: data!)
                    self.completionJSONClosure(jsonModel)
                    
                } catch {
                    
                }
                
            }
            
        }
        
        task.resume()
    }
    
    func httpMethod(_ md: HTTPMethod) -> SMNetWorking {
        self.op.httpMethod = md
        return self
    }
}

struct WModel: Codable {
    
}

/// use
SMNetWorking<WModel>().httpMethod(.POST).requestJSON(url: "www.baidu.com") { (model) in
    print(model)
}

