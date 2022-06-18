//
//  TrieNode.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 1/30/21.
//

import Foundation
import UIKit

class TrieNode<T: Hashable> {
    var isTerminating = false
    var value: T?
    weak var parent: TrieNode?
    var children: [T: TrieNode] = [:]
  
    init(value: T? = nil, parent: TrieNode? = nil) {
        self.value = value
        self.parent = parent
    }

    func add(child: T) {
      guard children[child] == nil else { return }
      children[child] = TrieNode(value: child, parent: self)
    }
}
