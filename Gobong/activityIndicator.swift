//
//  activityIndicator.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/14.
//

import Foundation
import NVActivityIndicatorView

class ActivityIndicator {
    static let shared = ActivityIndicator()

    func setupActivityIndicator(in view: UIView) -> NVActivityIndicatorView {
        let frame = CGRect(x: (view.frame.width - 100) / 2, y: (view.frame.height - 100) / 2, width: 100, height: 100)
        let type = NVActivityIndicatorType.ballScaleRippleMultiple
        let color = UIColor(named: "pink")
        let padding: CGFloat = 0
        
        let activityIndicatorView = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
        
        // Add it as a subview to your main view
        view.addSubview(activityIndicatorView)
        
        return activityIndicatorView
    }
}
