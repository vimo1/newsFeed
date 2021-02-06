import UIKit

class StoryImageLeftViewCell: StoryViewCell {
  
  private let headlineImageLeftView = HeadlineImageLeftView()
  
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
