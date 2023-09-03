//
//  DashedLineView.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/09.
//

import Foundation
import UIKit

class DashedLineView: UIView {
    var strokeColor: UIColor = UIColor(named: "softGray")! // Default color is black

    override func draw(_ rect: CGRect) {
        let dashPattern: [CGFloat] = [2, 2] // Adjust the pattern as needed
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width/2, y: 0))
        path.addLine(to: CGPoint(x: bounds.width/2, y: bounds.height))
        strokeColor.setStroke()
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
    
    func changeStrokeColor(color: UIColor) {
        strokeColor = color
        setNeedsDisplay() // This will trigger a redraw
    }

}
