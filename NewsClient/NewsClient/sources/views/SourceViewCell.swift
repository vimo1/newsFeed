import UIKit

protocol SourceViewCellListener: class {
  func switchToggled(for: SourceViewCell)
}

class SourceViewCell: UITableViewCell {

  let titleLabel = UILabel()
  let selectedSwitch = UISwitch()
  
  weak var listener: SourceViewCellListener?
  
  var title = "" {
    didSet {
      titleLabel.text = title
      selectedSwitch.isHidden = false
    }
  }
  
  var header = "" {
    didSet {
      titleLabel.text = header.capitalized
      selectedSwitch.isHidden = true
    }
  }
  
  var isSourceSelected = false {
    didSet {
      selectedSwitch.isOn = isSourceSelected
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpTableCell()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpTableCell() {
    translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    selectedSwitch.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.numberOfLines = 0
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(selectedSwitch)
    
    selectedSwitch.addTarget(self, action: #selector(switchToggled), for: .touchUpInside)
    
    titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 4).isActive = true
    
    selectedSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
    selectedSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    selectedSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
    selectedSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
//    selectedSwitch.heightAnchor.constraint(equalToConstant: 32).isActive = true
//    selectedSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
  }
  
  @objc
  func switchToggled(sender: UISwitch) {
    self.isSourceSelected = selectedSwitch.isOn
    listener?.switchToggled(for: self)
  }
}
