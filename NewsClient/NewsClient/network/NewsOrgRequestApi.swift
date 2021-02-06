//
//  RequestApi.swift
//  NewsClient
//

import Foundation

extension API {
  static func getTopHeadlines() -> Endpoint<TopHeadlinesResponse> {
    return Endpoint(path: "top-headlines", parameters: ["country": "us", "pageSize":100])
    
    
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
  
  static func getTopHeadlines(sources: String) -> Endpoint<TopHeadlinesResponse> {
    return Endpoint(path: "top-headlines", parameters: ["sources": sources])
  }
  
  static func getSources() -> Endpoint<SourcesResponse> {
    return Endpoint(path: "sources", parameters: ["language": "en"])
    
    
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
  
  static func search(query: String) -> Endpoint<TopHeadlinesResponse> {
    return Endpoint(path: "everything", parameters: ["q": query])
  }
  
  
//  
//  static func getComment(forId id: String) -> Endpoint<Comment> {
//    let path = String.init(format: "item/%@.json", id)
//    return Endpoint(path: path)
////    let path = "item/%@.json"
////    Alamofire.request(baseUrl + String.init(format: path, id)).responseJSON { response in
////
////      guard let data = response.data, let comment = try? JSONDecoder().decode(Comment.self, from: data) else {
////        return sucess(nil)
////      }
////      sucess(comment)
////    }
//  }
}
