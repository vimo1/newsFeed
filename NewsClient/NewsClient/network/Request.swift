//
//  Request.swift
//  NewsClient
//

import Alamofire
import RxSwift

enum API {}

class NewsApiRequest {
  private static let baseUrl = "https://newsapi.org/v2/"
  static let client = Client(baseUrl: baseUrl, accessToken: "338b847202284e45a344b0879cb9d20b")
  
  static func make<Response>(_ endPoint: Endpoint<Response>) -> Single<Response> {
    return client.request(endPoint)
  }
}

class HackerNewsRequest {
  private static let baseUrl = "https://hacker-news.firebaseio.com/v0/"
  static let client = Client(baseUrl: baseUrl)
  
  static func make<Response>(_ endPoint: Endpoint<Response>) -> Single<Response> {
    return client.request(endPoint)
  }
}

class NewsRoomRequest {
  private static let baseUrl = "https://gkz3ki9fah.execute-api.us-east-1.amazonaws.com/beta/"
  static let client = Client(baseUrl: baseUrl)
  
  static func make<Response>(_ endPoint: Endpoint<Response>) -> Single<Response> {
    return client.request(endPoint)
  }
}
