import UIKit

protocol HeadlineViewable {
  var contentView: HeadlineContentView { get }
  var imageView: UIImageView? { get }
}
