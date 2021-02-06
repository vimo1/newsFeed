//
//  serviceApis.swift
//  NewsClient

import Foundation
import FirebaseAuth
import FirebaseDatabase
import RxSwift

class ServiceApis {
  private static var userID: String? = nil
  private static var databaseReference: DatabaseReference? = nil
  
  static func configure(userID: String, databaseReference: DatabaseReference) {
    ServiceApis.userID = userID
    ServiceApis.databaseReference = databaseReference
  }
  
  static func getSavedStories(_ sucess: @escaping (([Int],[Story]))->()) {
    if let userID = userID, let ref = databaseReference {
      ref.child("users/\(userID)/savedStories").observeSingleEvent(of: .value, with: { (snapshot) in
        let values = snapshot.value as? [String : String] ?? [:]
        var result = (storyIds: [Int](), stories: [Story]())
        for (storyId, storyJson) in values {
          if let jsonData = storyJson.data(using: .utf8),
            let story = try? JSONDecoder().decode(Story.self, from: jsonData),
            let storyIdInt = Int(storyId) {
            result.storyIds.append(storyIdInt)
            result.stories.append(story)
          }
        }
        sucess(result)
      }) { (error) in
        print(error.localizedDescription)
      }
    }
  }
  
  static func getSavedStories() -> Single<([Int],[Story])> {
    return Single<([Int],[Story])>.create{ observer in
      var result = (storyIds: [Int](), stories: [Story]())
      if let userID = userID, let ref = databaseReference {
        ref.child("users/\(userID)/savedStories").observeSingleEvent(of: .value, with: { (snapshot) in
          let values = snapshot.value as? [String : String] ?? [:]
          for (storyId, storyJson) in values {
            if let jsonData = storyJson.data(using: .utf8),
              let story = try? JSONDecoder().decode(Story.self, from: jsonData),
              let storyIdInt = Int(storyId) {
              result.storyIds.append(storyIdInt)
              result.stories.append(story)
            }
          }
          observer(.success(result))
        }) { (error) in
          print(error.localizedDescription)
          observer(.error(error))
        }
        return Disposables.create {
          print("complete")
        }
      } else {
        return Disposables.create {
          observer(SingleEvent.error(NSError()))
        }
      }
    }
  }
  
  static func getSavedSources() -> Single<String> {
    return Single<String>.create{ observer in
      var result = ""
      if let userID = userID, let ref = databaseReference {
        ref.child("users/\(userID)/savedSources").observeSingleEvent(of: .value, with: { (snapshot) in
          let values = snapshot.value as? String ?? ""
          
          if let jsonData = values.data(using: .utf8),
            let sources = try? JSONDecoder().decode([String:String].self, from: jsonData) {
            result = sources["sources"] ?? ""
          }
          
          observer(.success(result))
        }) { (error) in
          print(error.localizedDescription)
          observer(.error(error))
        }
        return Disposables.create {
          print("complete")
        }
      } else {
        return Disposables.create {
          observer(SingleEvent.error(NSError()))
        }
      }
    }
  }
  
  static func saveStory(story: Story) {
    if let userID = userID,
      let ref = databaseReference,
      let encodedData = try? JSONEncoder().encode(story),
      let utf8Text = String(data: encodedData, encoding: .utf8) ,
      let storyId = story.id {
      ref.child("users/\(userID)/savedStories").child(String(storyId)).setValue(utf8Text)
    }
  }
  
  static func removeStory(storyId: Int) {
    if let userID = Auth.auth().currentUser?.uid,
      let ref = databaseReference {
      ref.child("users/\(userID)/savedStories").child(String(storyId)).removeValue()
    }
  }
  
  static func saveSources(sources: String) {
    let sourcesMap = ["sources":sources]
    if let userID = Auth.auth().currentUser?.uid,
      let ref = databaseReference,
      let encodedData = try? JSONEncoder().encode(sourcesMap){
      let utf8Text = String(data: encodedData, encoding: .utf8)
      ref.child("users/\(userID)/savedSources").setValue(utf8Text)
    }
  }
}
