//
//  HeadlineNoImageView.swift
//  NewsClient
//
import UIKit

class HeadlineNoImageView: UIView, HeadlineViewable {
  
  let contentView = HeadlineContentView()
  let imageView: UIImageView? = nil
  
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
    
    addSubview(contentView)
    
    contentView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
    contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
    contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
  }
}
