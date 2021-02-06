//
//  StoryWebViewController.swift
//  NewsClient

import UIKit

class StoryWebViewController: UIViewController {
  private let story: Story
  private let webView = UIWebView()
  
  init(story: Story) {
    self.story = story
    super.init(nibName: nil, bundle: nil)
    setupWebView()
    
    if let urlStr = story.url, let url = URL(string: urlStr)  {
      let request = URLRequest(url: url)
      webView.loadRequest(request)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupWebView() {
    webView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(webView)
    
    webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }
  
}
