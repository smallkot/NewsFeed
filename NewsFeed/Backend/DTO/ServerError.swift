import Foundation
import ObjectMapper

// MARK: - class ServerError

class ServerError: Mappable, CustomNSError {
  
  var message: String
  var status: String
  var code: String
  var allInfo: [String: Any] = [:]
  
  required init?(map: Map) {
    guard let nCode: String = try? map.value("code"),
      let nStatus: String = try? map.value("status"),
      let nMessage: String = try? map.value("message") else {
      return nil
    }
    self.code = nCode
    self.status = nStatus
    self.message = nMessage
  }
  
  func mapping(map: Map) {
    message <- map["message"]
    status <- map["status"]
    code <- map["code"]
    allInfo = map.JSON
  }
  
  static var errorDomain: String {
    return "Backend"
  }
  
  var errorUserInfo: [String : Any] {
    var info = allInfo
    info[NSLocalizedDescriptionKey] = self.message
    return info
  }
  
  var errorCode: Int {
    return 400
  }
  
  public static func from(error: Error) -> ServerError? {
    let json = (error as NSError).userInfo
    return Mapper<ServerError>().map(JSON: json)
  }
}
