//
//  NavigationController.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/15.
//

import Foundation
import UIKit

final class SwipeNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // IMPORTANT: without this if you attempt swipe on
    // first view controller you may be unable to push the next one
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}
