//
//  RssFeedCategoryListViewController.swift
//  NewsClient

import RIBs
import RxSwift
import UIKit

protocol RssFeedCategoryListPresentableListener: class {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
  var rssFeeds: [FeedsByCategory] { get }
  func getFeedFor(indexPath: IndexPath) -> RssFeedResponse?
  func selectedFeed(atIndexPath indexPath: IndexPath)
}

final class RssFeedCategoryListViewController: UIViewController, RssFeedCategoryListPresentable, RssFeedCategoryListViewControllable {
  
  weak var listener: RssFeedCategoryListPresentableListener?
  
  private let collectionFlowLayout: UICollectionViewFlowLayout
  let feedCategoriesCollectionView: UICollectionView
  
  init() {
    collectionFlowLayout = UICollectionViewFlowLayout()
    feedCategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  func pushRssFeed(viewController: ViewControllable) {
    if let navigationController = self.navigationController {
      navigationController.pushViewController(viewController.uiviewController, animated: true)
    }
  }
  
  // MARK: - private
  private func setupCollectionView() {
    feedCategoriesCollectionView.register(FeedItemCell.self, forCellWithReuseIdentifier: RssFeedCategoryListViewController.feedCategoryItemCellId)
    feedCategoriesCollectionView.register(CategoryHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RssFeedCategoryListViewController.feedCategoryHeaderCellId)
    
    collectionFlowLayout.headerReferenceSize = CGSize(width: feedCategoriesCollectionView.frame.size.width, height: 24)

    
    feedCategoriesCollectionView.backgroundColor = UIColor.white
    feedCategoriesCollectionView.dataSource = self
    feedCategoriesCollectionView.delegate = self
    
    view.addSubview(feedCategoriesCollectionView)
    
    feedCategoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
    feedCategoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    feedCategoriesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    feedCategoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    feedCategoriesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
  }
  
  private static let feedCategoryHeaderCellId = "feedCategoryHeaderCellId"
  private static let feedCategoryItemCellId = "feedCategoryItemCellId"
  private let sectionInsets = UIEdgeInsets(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)
  private let itemsPerRow: CGFloat = 4
}

// MARK: - UICollectionViewDataSource
extension RssFeedCategoryListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  //1
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return listener?.rssFeeds.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (listener?.rssFeeds[section])?.feeds.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RssFeedCategoryListViewController.feedCategoryHeaderCellId, for: indexPath) as! CategoryHeaderCell
    
    if let feedWithCategory = listener?.rssFeeds[indexPath.section] {
      headerView.header = feedWithCategory.category
    }
    
    return headerView
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //1
    guard listener?.rssFeeds.count ?? 0 > indexPath.section,
      let feed = listener?.getFeedFor(indexPath: indexPath) else {
        return UICollectionViewCell()
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RssFeedCategoryListViewController.feedCategoryItemCellId,
                                                  for: indexPath) as! FeedItemCell

    cell.updateCellContent(feed: feed)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    listener?.selectedFeed(atIndexPath: indexPath)
  }
}

// MARK: - Collection View Flow Layout Delegate
extension RssFeedCategoryListViewController : UICollectionViewDelegateFlowLayout {
  //1
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    //2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow

    return CGSize(width: widthPerItem, height: widthPerItem)
  }

  //3
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  // 4
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
