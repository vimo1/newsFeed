//
//  StoryViewCell.swift
//  NewsClient

import Foundation
import UIKit

class StoryImageRightViewCell: StoryViewCell {
  
  let headlineImageLeftView = HeadlineImageRightView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func getHeadlineView() -> (HeadlineViewable & UIView)? {
    return headlineImageLeftView
  }
}
