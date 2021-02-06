//
//  RequestApi.swift
//  NewsClient
//

import Foundation

extension API {
  static func getNewStories() -> Endpoint<[Int]> {
    return Endpoint(path: "topstories.json")
    
    
//    Alamofire.request(baseUrl + "topstories.json").responseJSON { response in
//      //      print("Request: \(String(describing: response.request))")   // original url request
//      //      print("Response: \(String(describing: response.response))") // http url response
//      //      print("Result: \(response.result)")                         // response serialization result
//
//      //      if let json = response.result.value {
//      //        print("JSON: \(json)") // serialized json response
//      //      }
//
//      if let data = response.data {
//        //        let utf8Text = String(data: data, encoding: .utf8)
//        //        print("Data: \(utf8Text)") // original server data as UTF8 string
//        if let storyIds = try? JSONDecoder().decode([Int].self, from: data) {
//          sucess(storyIds)
//        }
//      }
//    }
  }
  
  static func getStory(forId id: String) -> Endpoint<Story> {
    let path = String.init(format: "item/%@.json", id)
    return Endpoint(path: path)
//    let path = "item/%@.json"
//    Alamofire.request(baseUrl + String.init(format: path, id)).responseJSON { response in
//
//      guard let data = response.data, let story = try? JSONDecoder().decode(Story.self, from: data) else {
//        return sucess(nil)
//      }
//      sucess(story)
//    }
  }
  
  static func getComment(forId id: String) -> Endpoint<Comment> {
    let path = String.init(format: "item/%@.json", id)
    return Endpoint(path: path)
//    let path = "item/%@.json"
//    Alamofire.request(baseUrl + String.init(format: path, id)).responseJSON { response in
//
//      guard let data = response.data, let comment = try? JSONDecoder().decode(Comment.self, from: data) else {
//        return sucess(nil)
//      }
//      sucess(comment)
//    }
  }
  
  //MARK: - AWS News Room
  static func getRssJsonFeed(source: String? = nil) -> Endpoint<[RssFeedResponse]> {
    let source = source ?? "all"
    let path = "blogfeed/" + source
    return Endpoint(path: path)

  }
}
