import UIKit

class HeadlineImageLeftView: UIView, HeadlineViewable {
  
  let leftImageView = UIImageView()
  let contentView = HeadlineContentView()
  
  var imageView: UIImageView? {
    return leftImageView
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
    leftImageView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(leftImageView)
    addSubview(contentView)
    
    leftImageView.clipsToBounds = true
    leftImageView.contentMode = .scaleAspectFill
    
    contentView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
    contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    
    leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    leftImageView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -4).isActive = true
    leftImageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
    leftImageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    heightAnchor.constraint(greaterThanOrEqualToConstant: imageSize + 8).isActive = true
  }
  
  private let imageSize:CGFloat = 112  
}
