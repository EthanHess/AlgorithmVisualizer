//
//  Extensions.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 1/13/21.
//

import Foundation
import UIKit

extension UIView {
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
        //var returnElements : [Element] = []
        //MARK: Brute force, nested for loop (not ideal Big O)
        //O(n^2)
        for element in elementsToRemove {
            //Under the hood "contains" function will loop through array, which is linear (confirm this)
            if self.contains(where: { $0 == element }) == true {
                if let indexOfObj = self.firstIndex(of: element) {
                    self.remove(at: indexOfObj)
                }
            }
        }
        
        //MARK: More efficient, store a hashmap of current array and only iterate once
        
        var hashMap : [Element : Bool] = [:]
        
        //O(n)
        for theElement in elementsToRemove {
            hashMap[theElement] = true
        }
        
        //O(n)
        for theElementSelf in self {
            if hashMap[theElementSelf] == true {
                //MARK: "firstIndex" is O(n) so this needs to be more efficient
                if let indexOfObj = self.firstIndex(of: theElementSelf) {
                    self.remove(at: indexOfObj)
                }
            }
        }
    }
}
