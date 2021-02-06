//
//  RssFeedRouter.swift
//  NewsClient
//
//  Created by Vishal M on 2/24/19.
//  Copyright © 2019 Vishal M. All rights reserved.
//

import RIBs

protocol RssFeedInteractable: Interactable {
    var router: RssFeedRouting? { get set }
    var listener: RssFeedListener? { get set }
}

protocol RssFeedViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RssFeedRouter: ViewableRouter<RssFeedInteractable, RssFeedViewControllable>, RssFeedRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RssFeedInteractable, viewController: RssFeedViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
