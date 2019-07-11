import Alamofire
import Foundation
import ObjectMapper
import RxAlamofire
import RxSwift

private let errorStrings = R.string.localizable.self
/*
 * Базовый класс для наследования эндпоинтов
 */
class BaseEndpoint {
  private let validStatuses = [Int](200..<300)
  private let serverErrorMapper = Mapper<ServerError>()
  
  enum Errors: ErrorsProtocol {
    static var domain = "Backend"
    
    case invalidUrl(String)
    case incorrectResponse(String)
    case incorrectJSON(String)
    
    var info: ErrorInfo {
      switch self {
      case .invalidUrl(let url): return ErrorInfo(code: 9, description: errorStrings.backendErrorsInvalidUrl(), failureReason: url)
      case .incorrectJSON(let json): return ErrorInfo(code: 10, description: errorStrings.backendErrorsParse(), failureReason: json)
      case .incorrectResponse(let response): return ErrorInfo(code: 11, description: errorStrings.backendErrorsParse(), failureReason: response)
      }
    }
  }

  func endPoint() -> String? {
    return nil
  }

  private var baseService: BackendService
  required init(withBase base: BackendService) {
    baseService = base
  }

  func updateHeaders(forKey key: String, withValue value: String?) {
    baseService.updateHeaders(forKey: key, withValue: value)
  }

  private func buildUrl(forApiMethod apiMethod: String) -> Result<URL> {
    let urlString = baseService.baseUrl + baseService.supportedVersion + (self.endPoint() ?? "") + apiMethod
    if let url = URL(string: urlString) {
      return .success(url)
    } else {
      return .failure(Errors.invalidUrl(urlString))
    }
  }
  
  private func baseRequest<T>(apiMethod: String,
                              httpMethod: HTTPMethod,
                              encoding: ParameterEncoding = JSONEncoding.default,
                              params: [String: Any]? = nil,
                              converter: @escaping ((Any) -> T?)) -> Observable<T> {
    let url: URL
    switch buildUrl(forApiMethod: apiMethod) {
    case .failure(let error):
      return error.rx()
    case .success(let buildedUrl):
      url = buildedUrl
    }

    var nEncoding: ParameterEncoding = encoding
    
    if httpMethod == .get {
      nEncoding = URLEncoding(destination: URLEncoding.default.destination, arrayEncoding: URLEncoding.default.arrayEncoding, boolEncoding: URLEncoding.BoolEncoding.literal)
    }
    
    let dataRequest = request(url, method: httpMethod, parameters: params, encoding: nEncoding, headers: baseService.headers)
    //print(dataRequest.debugDescription)
    return dataRequest.rx.responseJSON()
      .retryOnConnect(timeout: 15)
      .map({ (response, data) -> T in
        if self.validStatuses.contains(response.statusCode) {
          if let result = converter(data) {
            return result
          } else {
            throw Errors.incorrectJSON(response.debugDescription)
          }
        }
        throw self.mapErrorObject(fromJson: data)
      })
  }

  // MARK: - Requests for mappables
  
  func requestArray<T: Mappable>(apiMethod: String,
                                 httpMethod: HTTPMethod,
                                 encoding: ParameterEncoding = JSONEncoding.default,
                                 params: [String: Any]? = nil,
                                 rootKey: String? = nil,
                                 mapper: Mapper<T> = Mapper<T>()) -> Observable<[T]> {
    return baseRequest(apiMethod: apiMethod, httpMethod: httpMethod, encoding: encoding, params: params, converter: { json -> [T]? in
      if let key = rootKey, let dict = json as? [String: Any] {
        return mapper.mapArray(JSONObject: dict[key])
      } else {
        return mapper.mapArray(JSONObject: json)
      }
    })
  }

  func requestObject<T: Mappable>(apiMethod: String,
                                  httpMethod: HTTPMethod,
                                  encoding: ParameterEncoding = JSONEncoding.default,
                                  params: [String: Any]? = nil,
                                  rootKey: String? = nil,
                                  mapper: Mapper<T> = Mapper<T>()) -> Observable<T> {
    return baseRequest(apiMethod: apiMethod, httpMethod: httpMethod, encoding: encoding, params: params, converter: { json -> T? in
      if let key = rootKey, let dict = json as? [String: Any] {
        return mapper.map(JSONObject: dict[key])
      } else {
        return mapper.map(JSONObject: json)
      }
    })
  }

  func mapErrorObject(fromJson json: Any) -> Error {
    if let errorObject = serverErrorMapper.map(JSONObject: json) {
      return errorObject
    }
    return Errors.incorrectJSON((json as AnyObject).debugDescription)
  }
}
