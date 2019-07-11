import Foundation
import RxSwift

extension Error {
  func rx<T>() -> Observable<T> {
    return Observable.error(self)
  }
}
