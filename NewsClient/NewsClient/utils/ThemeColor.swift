//
//  ThemeColor.swift
//  NewsClient

import UIKit

struct  ThemeColor {
  static let primaryColor = UIColor(red:1.00, green:0.56, blue:0.00, alpha:1.0)
  static let secondaryColor = UIColor(red:0.61, green:0.15, blue:0.69, alpha:1.0)
}

extension UIColor {
  convenience init?(hexString: String) {
    var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
    let red, green, blue, alpha: CGFloat
    switch chars.count {
    case 3:
      chars = chars.flatMap { [$0, $0] }
      fallthrough
    case 6:
      chars = ["F","F"] + chars
      fallthrough
    case 8:
      alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
      red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
      green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
      blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
    default:
      return nil
    }
    self.init(red: red, green: green, blue:  blue, alpha: alpha)
  }
}
