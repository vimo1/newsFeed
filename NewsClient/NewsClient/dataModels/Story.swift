//
//  Story.swift
//  NewsClient
/*
 {
 "by" : "dhouston",
 "descendants" : 71,
 "id" : 8863,
 "kids" : [ 8952, 9224, 8917, 8884, 8887, 8943, 8869, 8958, 9005, 9671, 8940, 9067, 8908, 9055, 8865, 8881, 8872, 8873, 8955, 10403, 8903, 8928, 9125, 8998, 8901, 8902, 8907, 8894, 8878, 8870, 8980, 8934, 8876 ],
 "score" : 111,
 "time" : 1175714200,
 "title" : "My YC app: Dropbox - Throw away your USB drive",
 "type" : "story",
 "url" : "http://www.getdropbox.com/u/2/screencast.html"
 }
 
 JSON: {
 by = nimz;
 id = 16401405;
 score = 1;
 time = 1518885645;
 title = "Fullstack Academy (YC S12) is hiring devs in New York who love teaching";
 type = job;
 url = "https://www.workable.com/j/279B5D89EA";
 }
 */

import Foundation

final class Story: Codable {
  
  var id: String? {
    if let idNumber = _idNumber {
      return String(idNumber)
    }
    return _source?.id
  }
  
  var title: String {
    return _title ?? ""
  }
  
  lazy var time: Date? = {
    if let timeInterval = _time {
      return Date(timeIntervalSince1970: timeInterval)
    } else if let publishedAt = _publishedAt {
      return DateUtils.shared.gmtDateFormatter.date(from: publishedAt)
    } else if let pubDate = _pubDate {
      return DateUtils.shared.rfc822DateFormatter.date(from: pubDate);
    }
    return nil
  }()
  
  var type: String? {
    return _type
  }
  var by: String? {
    return _by ?? _source?.name
  }
  var score: Int? {
    return _score
  }
  var url: String? {
    return _url ?? _link
  }
  
  var descendants: Int?{
    return _descendants
  }
  var kids: [Int]? {
    return _kids
  }
  
  var urlToImage: String? {
    return _urlToImage
  }
  
  private var _idNumber: Int?
  private var _title: String?
  private var _time: Double?
  private var _pubDate: String?
  private var _type: String?
  private var _by: String?
  private var _score: Int?
  private var _url: String?
  private var _link: String?
  private var _descendants: Int?
  private var _kids: [Int]?
  private var _source: StorySource?
  private var _description: String?
  private var _publishedAt: String?
  private var _urlToImage: String?
  
  init(id: Int? = nil, title: String? = "", url: String? = "", time: Double? = 0, type: String? = "", descendants: Int? = 0, by: String? = "", score: Int? = 0, kids: [Int]? = [], source: StorySource? = nil, description: String? = "", publishedAt: String? = nil, urlToImage: String?, link: String?, pubDate: String?) {
    self._idNumber = id
    self._title = title
    self._url = url
    self._link = link
    self._time = time
    self._pubDate = pubDate
    self._type = type
    self._descendants = descendants
    self._by = by
    self._score = score
    self._kids = kids
    
    self._source = source
    self._description = description
    self._publishedAt = publishedAt
    self._urlToImage = urlToImage
  }
  
  /// Overriding the property names, with custom property names
  /// when the json field is different, requires defining a `CodingKeys`
  /// enum and providing a case for each property. The case itself should
  /// match the property, and its rawValue of type string, should correspond
  /// to the JSON field name.
  enum CodingKeys: String, CodingKey {
    case _idNumber = "id"
    case _title = "title"
    case _time = "time"
    case _pubDate = "pubDate"
    case _type = "type"
    case _by = "by"
    case _score = "score"
    case _url = "url"
    case _link = "link"
    case _descendants = "decendents"
    case _kids = "kids"
    
    case _description = "description"
    case _source = "source"
    case _publishedAt = "publishedAt"
    case _urlToImage = "urlToImage"
  }
}


//final class Story2: Codable {
//    var title: String {
//      return _title ?? ""
//    }
//
//  private var _title: String?
//
//  init(title: String? = "") {
//    self._title = title
//  }
//
//  /// Overriding the property names, with custom property names
//  /// when the json field is different, requires defining a `CodingKeys`
//  /// enum and providing a case for each property. The case itself should
//  /// match the property, and its rawValue of type string, should correspond
//  /// to the JSON field name.
//  enum CodingKeys: String, CodingKey {
//    case _title = "title"
//  }
//}


//final class Story: Codable {
//  var id: String?
//  var title: String?
//  var time: Double?
//  var type: String?
//  var by: String?
//  var score: Int?
//  var url: String?
//  var descendants: Int?
//  var kids: [Int]?
//
//  var description: String?
//  var publishedAt: String?
//
//  init(id: Int = -1, title: String? = "", url: String? = "", time: Double? = 0, type: String? = "", descendants: Int? = 0, by: String? = "", score: Int? = 0, kids: [Int]? = [], source: StorySource? = nil, description: String? = "", publishedAt: String? = nil) {
//    self.id = String(id)
//    self.title = title
//    self.url = url
//    self.time = time
//    self.type = type
//    self.descendants = descendants
//    self.by = by
//    self.score = score
//    self.kids = kids
//
//    self.description = description
//    if let source = source {
//      self.id = source.id
//      self.by = source.name
//    }
//    if let publishedAt = publishedAt {
//      self.time = DateUtils.shared.gmtDateFormatter.date(from: publishedAt)?.timeIntervalSince1970
//    }
//
//  }
//}

final class Comment: Codable {
  var id: Int
  var time: Double
  var text: String
  var type: String
  var by: String
  var kids: [Int]?
  
  init(id: Int, time: Double = 0, text: String, type: String = "", by: String = "", kids: [Int]? = []) {
    self.id = id
    self.time = time
    self.text = text
    self.type = type
    self.by = by
    self.kids = kids
  }
}

final class StorySource: Codable {
  var id: String?
  var name: String
  
  init(id: String? = nil, name: String = "") {
    self.id = id
    self.name = name
  }
}

// #MARK: - News org api response

final class StoryHeadline: Codable {
  var source: StorySource
  var title: String
  var description: String
  var publishedAt: String
  var url: String?
  var descendants: Int?
  var kids: [Int]?
  
  init(source: StorySource, title: String = "", description: String = "", url: String? = "", publishedAt: String = "", descendants: Int? = 0, kids: [Int]? = []) {
    self.source = source
    self.title = title
    self.description = description
    self.url = url
    self.publishedAt = publishedAt
    self.descendants = descendants
    self.kids = kids
  }
}

final class TopHeadlinesResponse: Codable {
  var status: String
  var totalResults: Int
  //  var articles: [StoryHeadline]
  var articles: [Story]
  
  init(status: String,
       totalResults: Int,
       /*articles: [StoryHeadline]*/
    articles: [Story]) {
    self.status = status
    self.totalResults = totalResults
    self.articles = articles
  }
}

// #MARK: - AWS News Room api response
final class RssFeedResponse: Codable {
  var source: String
  var categories: [String]
  var iconUrl: String?
  var stories: [Story]
  
  init(source: String,
       categories: [String] = [],
       iconUrl: String?,
       stories: [Story]) {
    self.source = source
    self.categories = categories
    self.stories = stories
    self.iconUrl = iconUrl
  }
}
