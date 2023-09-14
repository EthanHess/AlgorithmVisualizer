//
//  Extensions.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 1/13/21.
//

import Foundation
import UIKit

extension UIView {
    
    //MARK: UI stuff
    //Anchoring
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        //Autoresizing mask controls how view resizes itself when (superview) bounds change
        //We don't want system to automatically create contraints so we'll set to false
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    //Shadow path
    
    //Referenced this tutorial / changed a few things (https://programmingwithswift.com/add-a-shadow-to-a-uiview-with-swift/)
    
    func customShadowPath(shadowHeight: CGFloat) {
        let layerX = self.layer.bounds.origin.x
        let layerY = self.layer.bounds.origin.y
        let layerWidth = self.layer.bounds.size.width
        let layerHeight = self.layer.bounds.size.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        
        path.addLine(to: CGPoint(x: layerX + layerWidth,
                                     y: layerY))
        path.addLine(to: CGPoint(x: layerX + layerWidth,
                                     y: layerHeight + 20))
        
        path.addCurve(to: CGPoint(x: 0,
                                      y: layerHeight),
                      controlPoint1: CGPoint(x: layerX + layerWidth,
                                                 y: layerHeight),
                      controlPoint2: CGPoint(x: layerX,
                                                 y: layerHeight))
        
        
        self.layer.shadowPath = path.cgPath
    }
    
    //Gradient (factor in vertical / multiple colors)
    func gradientWithColors(colorOne: UIColor, colorTwo: UIColor) {
        let gLayer = CAGradientLayer()
        gLayer.colors = [colorOne.cgColor, colorTwo.cgColor] //limit ?
        gLayer.locations = [0.0, 1.0] //vertical
        gLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gLayer.frame = self.bounds
        self.layer.insertSublayer(gLayer, at: 0)
    }
    
    //Get view w/h minus or plus whatever
    func viewWidth(_ minus: CGFloat, plus: CGFloat, shrink: Bool) -> CGFloat {
        let minusAdjusted = self.frame.size.width - minus
        let plusAdjusted = self.frame.size.width + plus
        return shrink == true ? minusAdjusted : plusAdjusted
    }
    
    func viewHeight(_ minus: CGFloat, plus: CGFloat, shrink: Bool) -> CGFloat {
        let minusAdjusted = self.frame.size.height - minus
        let plusAdjusted = self.frame.size.height + plus
        return shrink == true ? minusAdjusted : plusAdjusted
    }
}


extension Character {
    func isPlusOrMinus() -> Bool {
        return self == "+" || self == "-"
    }
    
    func toNumber() -> Int {
        return Int(String(self))!
    }
}

extension CGRect {
    var center : CGPoint {
        return CGPoint(x:self.midX, y:self.midY)
    }
}


typealias ArrayProtocols = Equatable & Hashable

extension Array where Element: ArrayProtocols {
    mutating func removeElements(_ elementsToRemove: [Element]) {
        
        //Brute force, not BigO ideal yet but will get the job done
        
        //MARK: Grab indices to remove
        var indicesToRemove : [Int] = []
        for i in 0..<self.count {
            let element = self[i]
            for theElement in elementsToRemove {
                if theElement == element {
                    indicesToRemove.append(i)
                }
            }
        }

        //Tediously mutate self without crashing due to out of bounds as elements shift
        let indicesSorted = indicesToRemove.sorted() //sorted() O(n log n)
        
        for i in (0..<self.count).reversed() { //reversed() is //O(1)
            if indicesSorted.contains(i) { //contains() is O(n)
                self.remove(at: i) //remove() is O(n)
            }
        }
        
        print("ARR after removal \(self)")
    }
}



//Random color for box
extension UIColor {
    static var random: UIColor {
        return .init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
    }
}

