//
//  AutocompleteViewController.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 1/30/21.
//

import UIKit

//TODO add
//MARK: https://github.com/airbnb/lottie-ios

//MARK: TODO, complete, debug this VC and make autocomplete func. work

class AutocompleteViewController: UIViewController {

    var theTrie : Trie?
    var results : [String] = []
    
    //Also add animations
    var searchTable : UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    //Can also add search results controller but this is more versatile 
    var searchBar : UISearchBar = {
        let sb = UISearchBar()
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Test
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let navCon = navigationController else {
            print("No NC")
            return
        }
        let skView = SceneKitViewController()
        navCon.pushViewController(skView, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //["i love you", "island","ironman", "i love leetcode"], [5,3,2,2]
        
        let arr = ["i love you", "island","ironman", "i love leetcode"]
        let times = [5,3,2,2]
        
        let autoCompleteSystem = AutocompleteSystem(sentences: arr, times: times)
        
        let listForCChar = autoCompleteSystem.input(char: "i")
        print("AUTOCOMPLETE \(listForCChar)")
        
        //For animation it's easier to have function locally instead of extension?
        //self.view.gradientWithColors(colorOne: .cyan, colorTwo: .white)
        
        self.gradientWithColorArray(colors: [.cyan, .white, .blue], theView: self.view)
        
        //Other approach (True or False for now but will add list of possibilities)
        setUpTrie()
    }
    
    //Gradient (factor in vertical / multiple colors)
    func gradientWithColorArray(colors: [UIColor], theView: UIView) {
        let startPoints : [NSNumber] = [-1.0,-0.5, 0.0]
        let endPoints : [NSNumber] = [1.0,1.5, 2.0]
        
        let gLayer = CAGradientLayer()
        gLayer.frame = theView.bounds
        gLayer.colors = colors.map({ color in
            return color.cgColor
        })
        gLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        theView.layer.insertSublayer(gLayer, at: 0)
        
        addGradientAnimation(startPoints, endPoints: endPoints, gradientLayer: gLayer)
    }
    
    //Shimmer handler
    fileprivate func addGradientAnimation(_ startPoints: [NSNumber], endPoints: [NSNumber], gradientLayer: CALayer) {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = startPoints
        animation.toValue = endPoints
        animation.duration = 1.0
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        gradientLayer.add(animation, forKey: nil)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.0
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity
        animationGroup.autoreverses = true
        gradientLayer.add(animationGroup, forKey: nil)
    }
    
    
    //Simple autocomplete
    fileprivate func tableSetup() {
        //Register
        searchTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchTable.delegate = self
        searchTable.dataSource = self
        
        searchBar.delegate = self
    }
    
    fileprivate func addToTrie() {
        let trie = Trie()
        self.theTrie = trie
        
        self.theTrie!.insert(word: "cut")
        self.theTrie!.insert(word: "cute")
        self.theTrie!.insert(word: "cutest")

        trie.insert(word: "cut")
        
        //TODO, if trie contains, add to table w / search bar
    }
    
    //Iterate this
    fileprivate func checkIfTrieContainsThenAddAndRefresh(text: String) {
        guard let tTrie = self.theTrie else {
            return
        }
        if tTrie.contains(word: text) {
            results.append(text)
        }
    }
    
    fileprivate func refresh() {
        DispatchQueue.main.async {
            self.searchTable.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AutocompleteViewController : UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = results[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    //MARK: Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        checkIfTrieContainsThenAddAndRefresh(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}




//MARK: More complex autocomplete code (move to algorithmator after test)

//MARK: Used some of this for reference / converted it to Swift from Java (Still tweaking a few things)

//https://leetcode.ca/2017-09-02-642-Design-Search-Autocomplete-System/

class AutocompleteSystem {
    
    var rootNode : ACNode?
    var currentNode : ACNode?
    var mutableStringBuffer = ""
    
    //MARK: Storing sentences (Memoization)
    //Example input = ["i love you", "island","ironman", "i love leetcode"], [5,3,2,2]
    init(sentences: Array<String>?, times: Array<Int>?) {
        guard let theSentences = sentences, let theTimes = times else { return }
        if times != nil && theSentences.count != theTimes.count { return }
        
        self.reset()
        self.rootNode = ACNode()
        
        for i in 0...theTimes.count - 1 {
            let sentenceToInsert = theSentences[i]
            let timeToInsert = theTimes[i]
            insert(sentence: sentenceToInsert, count: timeToInsert)
        }
    }
    
    func input(char: Character) -> [String] {
        var result : [String] = []
        
        if currentNode == nil { currentNode = rootNode }
        
        if char == "#" {
            insert(sentence: mutableStringBuffer, count: 1)
            reset()
            return result
        }
        
        mutableStringBuffer.append(char)
        if currentNode?.children[char] == nil {
            currentNode?.children[char] = ACNode()
            currentNode = currentNode?.children[char]
        }
        
        //Top 3 (or whatever) results
        result.append(contentsOf: findTop(node: currentNode!, k: 3))

        return result
    }
    
    func findTop(node: ACNode, k: Int) -> [String] {

        print("--- NODE --- \(node.frequency) -- \(node.children)")
        
        var result : [String] = []
        
        if node.frequency.isEmpty { return result }
        let frequencySorted = node.frequency.sorted(by: { $0.value < $1.value })
        
        for (key, value) in frequencySorted {
            print("--- DICT VAL ---\(value)")
            result.append(key)
        }
        
        return result
    }
    
    func insert(sentence: String?, count: Int) {
        guard let theSentence = sentence else { return }
        if theSentence.count == 0 { return }
        
        var node = rootNode
        
        let strArray = Array(theSentence)
        for char in strArray {
            if node!.children[char] == nil { node!.children[char] = ACNode() }
            node = node!.children[char]
            node!.frequency[theSentence] = (node!.frequency[theSentence] ?? 0) + count
        }
        node!.isEnd = true
    }
        
    
    func reset() {
        currentNode = nil
        mutableStringBuffer = ""
    }
}

class ACNode {
    var isEnd : Bool = false
    var frequency : Dictionary<String, Int>
    var children : Dictionary<Character, ACNode>
    
    init() {
        self.frequency = [:]
        self.children = [:]
    }
}

//Not using this yet
//class Pair {
//    var str : String
//    var count : Int
//
//    init() {
//        self.str = ""
//        self.count = 0
//    }
//}


//MARK: Different approach (True or False for now but will add list of possibilities)
//NOTE: Working perfectly!

extension AutocompleteViewController {
    fileprivate func setUpTrie() {
        let rootNode = AutocompleteNode(value: "")
        let autocompleteTrie = AutocompleteTrie(root: rootNode)
        
        //Search test
//        autocompleteTrie.insert(word: "DOG")
//        let dgTest = autocompleteTrie.search(word: "DG")
//        let doTest = autocompleteTrie.search(word: "DOG")
        
       // print("TF \(dgTest) -- \(doTest)")
        
        //TODO render trie w/ text field + table
        
        //Result test
        //Both time and space are O(n) for this
        let words = ["hello", "dog", "hell", "cat", "a", "hel", "help", "helps", "helping"]
        for word in words {
            autocompleteTrie.insert(word: word)
        }
        print("RESULT TEST \(autocompleteTrie.suggest("hel"))")
        print("CHILDREN \(autocompleteTrie.root.children)")
    }
}

typealias ChildMap = [String : AutocompleteNode]

class AutocompleteNode {
    var value : String
    var isEnd : Bool
    var children : ChildMap
    
    init(value: String, isEnd: Bool = false, children: ChildMap = [:]) {
        self.value = value
        self.isEnd = isEnd
        self.children = children
    }
}

class AutocompleteTrie {
    var root : AutocompleteNode
    init(root: AutocompleteNode) {
        self.root = root
    }
    func insert(word: String) {
        var current = self.root
        for char in strToCharArray(word) {
            let charString = charToString(char)
            if (current.children[charString] == nil) {
                current.children[charString] = AutocompleteNode(value: charString)
                print("CUR CHILDREN \(current.children)")
            }
            current = current.children[charString]!
        }
        print("CURRENT INSERT \(current)")
        current.isEnd = true
    }
    
    func search(word: String) -> Bool {
        var current = self.root
        for char in strToCharArray(word) {
            let charString = charToString(char)
            if (current.children[charString] == nil) {
                return false
            }
            current = current.children[charString]!
        }
        print("CURRENT SEARCH \(current)")
        return current.isEnd
    }
    
    //Helper
    func strToCharArray(_ str: String) -> Array<Character> {
        return Array(str)
    }
    func charToString(_ char: Character) -> String {
        return String(char)
    }
    
    //MARK:
    func suggestionHelper(_ root: AutocompleteNode, list: inout [String], current: String) {
        if root.isEnd {
            list.append(current)
        }
        if root.children.isEmpty {
            return
        }
        let allKeys = root.children.keys
        for childMap in allKeys {
            let newRoot = root.children[childMap]!
            let newCurrent = current.appending(childMap)
            suggestionHelper(newRoot, list: &list, current: newCurrent)
        }
    }
    
    func suggest(_ prefix: String) -> [String] {
        var current = ""
        var list : [String] = []
        var theRoot = self.root //Assume exists, mandatory init param (start at top here and traverse tree)
        let prefixArray = strToCharArray(prefix)
        for i in 0..<prefixArray.count {
            //Check child map (node children dict of char strings that point to child nodes)
            let curChar = charToString(prefixArray[i])
            if theRoot.children[curChar] == nil { //Doesn't exist
                return [] //char is not in child map
            }
            theRoot = theRoot.children[curChar]!
            current += curChar
        }
        suggestionHelper(theRoot, list: &list, current: current)
        return list
    }
}
