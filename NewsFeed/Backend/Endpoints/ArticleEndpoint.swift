//
//  AuthEndpoint.swift
import Foundation
import ObjectMapper
import RxSwift
import Alamofire

class ArticleEndpoint: BaseEndpoint {
  override func endPoint() -> String? {
    return "/everything"
  }
  
  required init(withBase base: BackendService) {
    super.init(withBase: base)
  }
  
  func getArticles(page: Int = 1, pageSize: Int = 5) -> Observable<[Article]> {
    let params = [
      "page": page,
      "pageSize": pageSize,
      "q": "android",
      "from": "2019-04-00",
      "sortBy": "publishedAt",
      "apiKey": "26eddb253e7840f988aec61f2ece2907"
    ] as [String: Any]
    return requestArray(
      apiMethod: "",
      httpMethod: .get,
      params: params,
      rootKey: "articles")
  }
}
