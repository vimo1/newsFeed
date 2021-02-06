import UIKit

class HeadlineImageRightView: UIView, HeadlineViewable {
  
  let rightImageView = UIImageView()
  let contentView = HeadlineContentView()
  
  var imageView: UIImageView? {
    return rightImageView
  }
  
  init() {
    super.init(frame: CGRect.zero)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    rightImageView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(rightImageView)
    addSubview(contentView)
    
    rightImageView.clipsToBounds = true
    rightImageView.contentMode = .scaleAspectFill
    
    contentView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
    contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
    contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    
    rightImageView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    rightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    rightImageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
    rightImageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    heightAnchor.constraint(greaterThanOrEqualToConstant: imageSize + 8).isActive = true
  }
  
  private let imageSize:CGFloat = 112
}
