import Alamofire
import Foundation
import RxSwift

protocol ClientProtocol {
  func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response>
}

final class Client: ClientProtocol {
  private let manager: Alamofire.SessionManager
  private let queue = DispatchQueue(label: "newsRequestQueue")
  private let baseURL: URL?
  
  init(baseUrl: String, accessToken: String? = nil) {
    baseURL = URL(string: baseUrl)
    var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    
    let configuration = URLSessionConfiguration.default
    
    // Add `Auth` header to the default HTTP headers set by `Alamofire`
    if let accessToken = accessToken {
      defaultHeaders["Authorization"] = "Bearer \(accessToken)"
      configuration.httpAdditionalHeaders = defaultHeaders
    }
    
    self.manager = Alamofire.SessionManager(configuration: configuration)
  }
  
  func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
    
    return Single<Response>.create { observer in
      
      if let endPointUrl = self.url(path: endpoint.path) {
        let request = self.manager.request (
          endPointUrl,
          method: httpMethod(from: endpoint.method),
          parameters: endpoint.parameters
        )
        request
          .validate()
          .responseData(queue: self.queue) { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
              print("JSON: \(json)") // serialized json response
            }
            
                  if let data = response.data {
                            let utf8Text = String(data: data, encoding: .utf8)
                    print("Data: \(String(describing: utf8Text))") // original server data as UTF8 string
//                    if let storyIds = try? JSONDecoder().decode([Int].self, from: data) {
//                      sucess(storyIds)
//                    }
                  }
            
            let result = response.result.flatMap(endpoint.decode)
            switch result {
            case let .success(val): observer(.success(val))
            case let .failure(err): observer(.error(err))
            }
        }
        return Disposables.create {
          request.cancel()
        }
      } else {
        return Disposables.create {
          observer(SingleEvent.error(NSError()))
        }
      }
    }
  }
  
  private func url(path: Path) -> URL? {
    return baseURL?.appendingPathComponent(path)
  }
}

private func httpMethod(from method: Method) -> Alamofire.HTTPMethod {
  switch method {
  case .get: return .get
  case .post: return .post
  case .put: return .put
  case .patch: return .patch
  case .delete: return .delete
  }
}
