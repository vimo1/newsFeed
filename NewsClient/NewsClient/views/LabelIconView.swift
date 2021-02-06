//
//  LabelIcon.swift
//  NewsClient

import UIKit

class LabelIconView: UIView {
  
  let textLabel = UILabel()
  let imageView = UIImageView()
  
  init() {
    super.init(frame: CGRect.zero)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    translatesAutoresizingMaskIntoConstraints = false
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(textLabel)
    addSubview(imageView)

    textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    textLabel.textAlignment = .right
    textLabel.font = UIFont.systemFont(ofSize: 12.0)

    imageView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 1).isActive = true
    imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
    imageView.contentMode = .scaleAspectFit
  }
}
