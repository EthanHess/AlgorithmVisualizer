//
//  TreeNode.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 6/7/22.
//

import Foundation
import UIKit

//MARK: Move to own Swift file
public class TreeNode {
     public var val: Int
     public var left: TreeNode?
     public var right: TreeNode?
     public init() { self.val = 0; self.left = nil; self.right = nil; }
     public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
     public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
         self.val = val
         self.left = left
         self.right = right
     }
}
