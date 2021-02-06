//
//  StoryViewCell.swift
//  NewsClient

import Foundation
import UIKit

protocol StoryViewCellListener: class {
  func shareStory(cell: UITableViewCell)
}

class StoryViewCell: UITableViewCell {
  
  weak var listener: StoryViewCellListener?
  
  private let commentsView = LabelIconView()
  private let pointsView = LabelIconView()
  private var headlineView: (HeadlineViewable & UIView)?
  
  private var commentsHeightConstraint: NSLayoutConstraint?
  private var pointsHeightConstraint: NSLayoutConstraint?
  
  var title = "" {
    didSet {
      headlineView?.contentView.titleLabel.text = title
    }
  }
  
  var htmlText = "" {
    didSet {
      guard !htmlText.isEmpty else { return }
      let textFont = UIFont.systemFont(ofSize: 13.0)
      let fontSize = "\(textFont.pointSize)"
      guard let data = ("<div style=\"font-family: '" + textFont.fontName + "'; font-size: " + fontSize + ";\">" + htmlText + "</div>")
        .data(using: String.Encoding.unicode) else { return }
      if let attr = try? NSMutableAttributedString(data: data,
                                                   options: [.documentType: NSAttributedString.DocumentType.html],
                                                   documentAttributes: nil) {
        headlineView?.contentView.titleLabel.attributedText = attr
      }
    }
  }
  
  var url: String? {
    didSet {
      if let urlStr = url {
        let storyUrl = URL(string: urlStr)
        headlineView?.contentView.urlLabel.text = storyUrl?.host
        headlineView?.contentView.urlLabel.isHidden = false
      } else {
        headlineView?.contentView.urlLabel.isHidden = true
      }
    }
  }
  
  var time: Date? = nil {
    didSet {
      if let storyTime = time {
        headlineView?.contentView.timeLabel.text = DateUtils.shared.shortDateFormatter.string(from: storyTime)
      }
    }
  }
  
  var publishedAt = "" {
    didSet {
      if let storyTime = DateUtils.shared.gmtDateFormatter.date(from: publishedAt) {
        headlineView?.contentView.timeLabel.text = DateUtils.shared.shortDateFormatter.string(from: storyTime)
      }
    }
  }
  
  var kids: [Int] = [] {
    didSet {
      commentsView.textLabel.text = String(kids.count)
      commentsView.isHidden = kids.isEmpty
      commentsHeightConstraint?.isActive = !commentsView.isHidden
    }
  }
  
  var points: Int = 0 {
    didSet {
      pointsView.textLabel.text = String(points)
      pointsView.isHidden = points == 0
      pointsHeightConstraint?.isActive = !pointsView.isHidden
    }
  }
  
  var imageUrl: String? = nil {
    didSet {
      if let imageUrl = imageUrl {
        headlineView?.imageView?.isHidden = false
        headlineView?.imageView?.imageFromServerURL(imageUrl, placeHolder: UIImage(named: "baseline_photo_black_36pt"))
      } else {
        headlineView?.imageView?.isHidden = true
      }
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.headlineView = getHeadlineView()
    setUpTableCell()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open func getHeadlineView() -> (HeadlineViewable & UIView)? {
    return nil
  }
  
  func setUpTableCell() {
    if let headlineView = headlineView {
      contentView.addSubview(headlineView)
      headlineView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
      headlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
      headlineView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
      headlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
      
      headlineView.contentView.shareButton.addTarget(self, action: #selector(shareStory), for: UIControl.Event.touchUpInside)
    }
  }
  
  @objc
  private func shareStory() {
    listener?.shareStory(cell: self)
  }
}
