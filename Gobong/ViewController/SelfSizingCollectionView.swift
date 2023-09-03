//
//  SelfSizingCollectionVie.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/09.
//

import Foundation
import UIKit

class SelfSizingCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
    
}
