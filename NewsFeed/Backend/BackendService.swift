import Alamofire
import Foundation

/*
 * Shared service for endpoints
 */
class BackendService {
  
  // MARK: - Support
  var baseUrl: String = {
    return (Bundle.main.object(forInfoDictionaryKey: "baseURL") as? String ?? "")
  }()
  
  private(set) var headers: [String: String] = [
    "Content-Type": "application/json"
  ]
  
  var supportedVersion: String = {
    return Bundle.main.object(forInfoDictionaryKey: "SupportedAPIversion") as? String ?? ""
  }()
  
  func updateHeaders(forKey key: String, withValue value: String?) {
    if let newValue = value {
      headers[key] = newValue
    } else {
      headers.removeValue(forKey: key)
    }
  }
}
