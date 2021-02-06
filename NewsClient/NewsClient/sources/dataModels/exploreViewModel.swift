
enum ExploreViewModelItemType {
  case source
  case story
}

protocol ExploreViewModelItem {
  var type: ExploreViewModelItemType { get }
  var rowCount: Int { get }
  var sectionName: String { get }
}

extension ExploreViewModelItem {
  var rowCount: Int {
    return 1
  }
}

class SourceExploreViewModelItem: ExploreViewModelItem {
  var type: ExploreViewModelItemType {
    return .source
  }
  
  private(set) var sectionName: String
  
  var rowCount: Int {
    return sources.count
  }
  
  let sources: [Source]
  
  init(sectionName: String, sources: [Source]) {
    self.sectionName = sectionName
    self.sources = sources
  }
}

class StoryExploreViewModelItem: ExploreViewModelItem {
  var type: ExploreViewModelItemType {
    return .story
  }
  
  private(set) var sectionName: String
  
  var rowCount: Int {
    return stories.count
  }
  
  let stories: [Story]
  init(sectionName: String, stories: [Story]) {
    self.sectionName = sectionName
    self.stories = stories
  }
}

class ExploreViewModel {
  var items = [ExploreViewModelItem]()
  
  init(sources: [Source], stories: [Story] = []) {
    buildViewModel(sources: sources, stories: stories)
  }
  
  private func buildViewModel(sources: [Source], stories: [Story]){
    var countries = Set<String>()
    var categories = Set<String>()
    var categorySourceMap: [String: [Source]] = [:]
    
    for source in sources {
      countries.insert(source.country)
      categories.insert(source.category)
      
      if categorySourceMap[source.category] == nil {
        categorySourceMap[source.category] = []
      } else {
        categorySourceMap[source.category]?.append(source)
      }
    }
    
//    let countryList = countries.sorted()
    if !stories.isEmpty {
      items.append(StoryExploreViewModelItem(sectionName: "Search Results", stories: stories))
    }
    
    let categoryList = categories.sorted()
    for category in categoryList {
      if let sources = categorySourceMap[category] {
        items.append(SourceExploreViewModelItem(sectionName: category, sources: sources))
      }
    }
  }
}
