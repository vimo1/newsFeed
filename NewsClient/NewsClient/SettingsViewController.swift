//
//  SettingsViewController.swift
//  NewsClient


import UIKit

class SettingsViewController: UIViewController {

  static func getSettingsViewController () -> SettingsViewController{
    return SettingsViewController()
  }
  
  private init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
