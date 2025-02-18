//
//  DateUtils.swift
//  NewsClient
//
import Foundation

class DateUtils {
  
  static let shared = DateUtils()

  let shortDateFormatter: DateFormatter;
  let gmtDateFormatter: DateFormatter;
  let rfc822DateFormatter: DateFormatter;
  
  private init() {
    shortDateFormatter = DateFormatter()
    shortDateFormatter.dateStyle = .short
    shortDateFormatter.timeStyle = .short
    
    gmtDateFormatter = DateFormatter()
    gmtDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    rfc822DateFormatter = DateFormatter()
    rfc822DateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
  }
}

extension ISO8601DateFormatter {
  convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
    self.init()
    self.formatOptions = formatOptions
    self.timeZone = timeZone
  }
}

extension Formatter {
  static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension String {
  var iso8601: Date? {
    return Formatter.iso8601.date(from: self)
  }
}
