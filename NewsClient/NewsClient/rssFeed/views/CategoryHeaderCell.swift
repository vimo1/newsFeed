//
//  CategoryHeaderCell.swift
//  NewsClient
//
import UIKit
import SnapKit

class CategoryHeaderCell: UICollectionReusableView {
  
  private let headerLabel = UILabel()

  var header = "" {
    didSet {
      headerLabel.text = header.uppercased()
    }
  }
  
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
  
  private func setupViews() {
    addSubview(headerLabel)
    
    headerLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
    
    headerLabel.snp.remakeConstraints { (maker: ConstraintMaker) in
      maker.bottom.equalToSuperview()
      maker.top.equalToSuperview().offset(8)
      maker.leading.trailing.equalToSuperview().offset(16)
    }
  }
}
