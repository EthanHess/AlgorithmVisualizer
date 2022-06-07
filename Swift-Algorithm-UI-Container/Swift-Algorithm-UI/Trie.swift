//
//  Trie.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 1/30/21.
//

import Foundation
import UIKit

//Character is a @frozen struct, limiting the changes you can make to the type
class Trie {
  typealias Node = TrieNode<Character>
  fileprivate let root: Node
  init() {
    root = Node()
  }
}

extension Trie {
    
  func insert(word: String) {
    guard !word.isEmpty else { return }
    var currentNode = root
    //No longer need .characters
    let characters = Array(word.lowercased())
    var currentIndex = 0
    
    while currentIndex < characters.count {
      let character = characters[currentIndex]
      if let child = currentNode.children[character] {
        currentNode = child
      } else {
        currentNode.add(child: character)
        currentNode = currentNode.children[character]!
      }
      currentIndex += 1
        
      if currentIndex == characters.count {
        currentNode.isTerminating = true
      }
    }
  }
    
    func contains(word: String) -> Bool {
        guard !word.isEmpty else { return false }
        var currentNode = root

        let characters = Array(word.lowercased())
        var currentIndex = 0
        
        while currentIndex < characters.count, let child = currentNode.children[characters[currentIndex]] {
            currentIndex += 1
            currentNode = child
        }
        
        //Ternary would be cleaner
        if currentIndex == characters.count && currentNode.isTerminating {
          return true
        } else {
          return false
        }
    }
}
