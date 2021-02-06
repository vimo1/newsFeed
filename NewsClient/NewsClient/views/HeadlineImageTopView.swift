import UIKit

class HeadlineImageTopView: UIView, HeadlineViewable {
  
  let topImageView = UIImageView()
  let contentView = HeadlineContentView()
  
  var imageView: UIImageView? {
    return topImageView
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
    topImageView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(contentView)
    addSubview(topImageView)
    
    topImageView.clipsToBounds = true
    topImageView.contentMode = .scaleAspectFill
    
    topImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
    topImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    topImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    topImageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    
    contentView.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 4).isActive = true
    contentView.leadingAnchor.constraint(equalTo: topImageView.leadingAnchor, constant: 4).isActive = true
    contentView.trailingAnchor.constraint(equalTo: topImageView.trailingAnchor).isActive = true
    contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
  }
  
  private let imageSize:CGFloat = 172
}
