//
//  FeedCategoryHeaderCell.swift
//  NewsClient


import UIKit
import SnapKit

class FeedItemCell: UICollectionViewCell {
  
  private let colors = [UIColor(hexString: "#364156"),
                        UIColor(hexString: "#912F40"),
                        UIColor(hexString: "#D66853"),
                        UIColor(hexString: "#463F3A")]
  private let titleLabel = UILabel()
  private let iconImageView = UIImageView()
  
  init() {
    super.init(frame: CGRect.zero)
    setupViews()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.snp.removeConstraints()
    titleLabel.snp.removeConstraints()
    iconImageView.isHidden = true
    titleLabel.isHidden = true
  }
  
  func updateCellContent(feed: RssFeedResponse) {
    if let iconUrl = feed.iconUrl, iconUrl.count > 0 {
      iconImageView.isHidden = false
      iconImageView.imageFromServerURL(iconUrl, placeHolder: UIImage(named: "baseline_photo_black_36pt"))
      iconImageView.snp.remakeConstraints { (maker: ConstraintMaker) in
        maker.centerY.leading.trailing.equalToSuperview()
        maker.height.equalTo(imageSize)
      }
    } else {
      titleLabel.isHidden = false
      titleLabel.text = feed.source
      titleLabel.backgroundColor = colors[Int.random(in: 0 ..< colors.count)]
      titleLabel.snp.remakeConstraints { (maker: ConstraintMaker) in
        maker.edges.equalToSuperview()
      }
    }
  }
  
  private func setupViews() {
    translatesAutoresizingMaskIntoConstraints = false
    
    iconImageView.contentMode = .scaleAspectFit
    
    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
    titleLabel.textColor = UIColor.white
    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 7
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(iconImageView)
    
    iconImageView.snp.makeConstraints { (maker: ConstraintMaker) in
      maker.top.leading.trailing.equalToSuperview()
      maker.height.equalTo(imageSize)
    }
  }
  
  private let imageSize:CGFloat = 72
}
