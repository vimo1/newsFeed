
//{
//  "id": "abc-news",
//  "name": "ABC News",
//  "description": "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com.",
//  "url": "https://abcnews.go.com",
//  "category": "general",
//  "language": "en",
//  "country": "us"
//}

final class Source: Codable {
  var id: String
  var name: String
  var description: String
  var url: String
  var category: String
  var country: String
}

final class SourcesResponse: Codable {
  var status: String
  var sources: [Source]
}

