import Foundation

extension Date {
  static func dateFromString(dateStr: String, format: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    if let date = formatter.date(from: dateStr) {
      return date
    }
    return nil
  }
  
  func shortTime(format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
}
