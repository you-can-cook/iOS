//
//  FeedBoxCell.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/02.
//

import UIKit

class FeedBoxCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.contentMode = .scaleAspectFill
    }

}
