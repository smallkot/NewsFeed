import Foundation
import RealmSwift

enum RealmError: Error {
  case invalidated
}

final class RealmStorage {
  
  // MARK: - ОБЩИЕ ФУНЦИИ
  static let `default`: RealmStorage = RealmStorage()
  fileprivate(set) var invalidated: Bool = false
  
  var realm: Realm {
    let realm = try! Realm()
    realm.autorefresh = true
    return realm
  }
  
  @discardableResult
  func write(to: Realm? = nil, _ block: (Realm) -> Void) -> Error? {
    guard invalidated == false else { return RealmError.invalidated }
    do {
      let transaction: Realm = to ?? realm
      var shouldCommitTransaction: Bool = false
      if !transaction.isInWriteTransaction {
        transaction.beginWrite()
        shouldCommitTransaction = true
      }
      block(transaction)
      if shouldCommitTransaction {
        try transaction.commitWrite()
      }
      return nil
    } catch {
      return error
    }
  }
  
  @discardableResult
  func setArticle(_ article: Article, realm: Realm? = nil) -> Article {
    var result = article
    write(to: realm) { (realm) in
      if let _item = realm.object(ofType: Article.self, forPrimaryKey: article.title) {
        result = _item
      } else {
        realm.add(article, update: true)
        result = article
      }
    }
    return result
  }
  
  func getArticles() -> [Article] {
    return Array(realm.objects(Article.self))
  }
}

