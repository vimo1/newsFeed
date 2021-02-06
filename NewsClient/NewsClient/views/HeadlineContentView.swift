import UIKit

class HeadlineContentView: UIView {
  
  let titleLabel = UILabel()
  let urlLabel = UILabel()
  let timeLabel = UILabel()
  let shareButton = UIButton(type: UIButton.ButtonType.custom)
  
  init() {
    super.init(frame: CGRect.zero)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    urlLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    shareButton.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.numberOfLines = 0
    
    shareButton.tintColor = UIColor.gray
    shareButton.setImage(UIImage(named: "share_icon_18pt"), for: .normal)
    shareButton.imageView?.contentMode = .scaleAspectFit
    
    addSubview(titleLabel)
    addSubview(urlLabel)
    addSubview(timeLabel)
    addSubview(shareButton)
    
    urlLabel.font = UIFont.systemFont(ofSize: 12.0)
    urlLabel.textColor = UIColor.gray
    timeLabel.font = UIFont.systemFont(ofSize: 12.0)
    timeLabel.textColor = UIColor.gray
    
    urlLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    urlLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
    urlLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    
    titleLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 4).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    
    timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
    timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
    timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
    shareButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
    shareButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -8).isActive = true
    shareButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    shareButton.widthAnchor.constraint(equalToConstant: shareImageSize).isActive = true
    shareButton.heightAnchor.constraint(equalToConstant: shareImageSize).isActive = true
  }
  
  private let imageSize:CGFloat = 112
  private let shareImageSize:CGFloat = 16.0
}

