import Foundation
import ObjectMapper

import RealmSwift

class Article: Object, Mappable {
  @objc dynamic var source: Source?
  @objc dynamic var author: String?
  @objc dynamic var title: String?
  @objc dynamic var descriptionArticle: String?
  @objc dynamic var url: String?
  @objc dynamic var urlToImage: String?
  @objc dynamic var publishedAt: Date?
  @objc dynamic var content: String?
  
  let transformDate = TransformOf<Date, AnyObject>(fromJSON: { (value: AnyObject?) -> Date? in
    return Date.dateFromString(dateStr: (value as? String) ?? "", format: "yyyy-MM-dd'T'HH:mm:ssZ")
  }, toJSON: { (_: Date?) -> AnyObject? in
    return nil
  })
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  override class func primaryKey() -> String? {
    return "title"
  }
  
  func mapping(map: Map) {
    source <- map["source"]
    author <- map["author"]
    title <- map["title"]
    descriptionArticle <- map["description"]
    url <- map["url"]
    urlToImage <- map["urlToImage"]
    publishedAt <- (map["publishedAt"], transformDate)
    content <- map["content"]
  }
}

class Source: Object, Mappable {
  @objc dynamic var id: String?
  @objc dynamic var name: String?
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
  }
}


