import Foundation

//MARK: - Structure
public struct ErrorInfo {
  let code: Int
  let description: String
  let failureReason: String?
}

public protocol ErrorsProtocol: CustomNSError {
  ///Домен - имя сервиса
  static var domain : String { get }
  
  ///Код ошибки, описание для пользователя, причина ошибки для логгирования
  var info : ErrorInfo { get }
}

public extension ErrorsProtocol {
  static var errorDomain: String { get {
    return Self.domain
    }
  }
  
  var errorUserInfo: [String : Any] {
    get {
      return [
        NSLocalizedDescriptionKey: info.description,
        NSLocalizedFailureReasonErrorKey: info.failureReason ?? ""
      ]
    }
  }
  
  public var errorCode: Int {
    get {
      return info.code
    }
  }
}

//MARK: - Comprasion
public func == <E : ErrorsProtocol> (left: E, right: NSError) -> Bool {
  return (E.domain == right.domain) && (left.info.code == right.code)
}

public func == <E : ErrorsProtocol> (left: NSError, right: E) -> Bool {
  return (E.domain == left.domain) && (right.info.code == left.code)
}
