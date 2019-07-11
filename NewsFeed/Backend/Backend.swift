import Alamofire
import Foundation
import ObjectMapper

/*
 * Aggregation
 */
class Backend {
  private let baseService: BackendService
  let article: ArticleEndpoint
  
  init() {
    baseService = BackendService()
    article = ArticleEndpoint(withBase: baseService)
  }
  
  func newEndpoint<T: BaseEndpoint>() -> T {
    return T(withBase: self.baseService)
  }
}
