//
//  ViewController.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 12/27/20.
//

import UIKit

enum DisplayType {
    case collectionView
    case customAnimationView
}

enum AlgorithmType {
    case binarySearch
    case mergeSort
    case peakFinder
    case buildingsArray
    case autoComplete
}

//Check which view (if any) is currently animating on / off screen
enum AnimationType {
    case collection
    case graphView
    case none
}

typealias ScrollHandler = ScrollIndexDidChange

let kNotificationNameAlgorithmDataUpdated = "AlgorithmDataUpdated"

//TODO break down
let kNotificationNameCalculatorAlgorithmUpdated = "CalulatorAlgorithmUpdated"

class ViewController: UIViewController, ScrollHandler {

    //MARK: lazy = only computed once / initialized only when needed (Not thread safe though, so use only with very expensive objects / operations that may be called a lot) (i.e. a date picker)

    lazy var scrollPicker : AlgorithmChoiceScroll = {
        let acs = AlgorithmChoiceScroll()
        return acs
    }()
    
    lazy var graphRenderer : GraphFunctionsRenderer = {
        let gr = GraphFunctionsRenderer()
        return gr
    }()
    
    lazy var stringRenderer : StringFunctionsRenderer = {
        let sr = StringFunctionsRenderer()
        return sr
    }()
    
    lazy var calculatorRenderer : CalculatorView = {
        let cr = CalculatorView()
        return cr
    }()
    
    //
    lazy var collection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var collectionOffscreen = false
    var isAnimatingCollection = false
    
    var originalCVFrame = CGRect.zero
    var originalGraphFrame = CGRect.zero
    
    //MARK: Enums
    var displayType : DisplayType = .collectionView
    var algorithmType : AlgorithmType = .binarySearch //Default, TODO update
    
    //var isAnimating = false //animate the algorithm + present Time/Space/Runtime etc.
    
    var animationType : AnimationType = .none
    
    var collectionViewPopulatorMatrix : [[Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIConfig()
        addObserverForKeyPath("") //No more path, use Combine
        
        self.view.gradientWithColors(colorOne: .cyan, colorTwo: .white)
        
        //Will now be called individually on scroll click
        //algorithmTest()
        //longestCommonPrefix()
        validParenthesisWrapper()
    }
    
    fileprivate func longestCommonPrefix() {
        let arr = ["aac","acab","aa","abba","aa"]
        let returnStr = Algorithmator.longestCommonPrefix(arr)
        print("ARR \(returnStr)")
    }
    
    //MARK: Setup tab bar, this is just a test
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let navCon = navigationController else {
//            print("No NC")
//            return
//        }
//        let autocompleteView = AutocompleteViewController()
//        navCon.pushViewController(autocompleteView, animated: true)
//    }
    
    fileprivate func algorithmTest() {
        Algorithmator.recurSubviewsOfView(theView: self.view)
        
        let bldgArr = [8, 4, 9, 10, 3, 2, 5, 16, 3]
        let bldgWithView = Algorithmator.buildingsFacingTheSea(buildingArray: bldgArr)
        
        print("-- BUILDINGS WITH A VIEW -- \(bldgWithView)")
        
        let mergeSort = Algorithmator.mergeSort(array: bldgArr)
        let mergeSortRW = Algorithmator.mergeSortRW(bldgArr)
        
        print("-- MERGE SORT -- \(mergeSort)")
        print("-- MERGE SORT RW -- \(mergeSortRW)")
        
        let quickSort = Algorithmator.quickSortWithArray(array: bldgArr)
        let quickSortRW = Algorithmator.quicksortRW(bldgArr)
        
        print("-- QUICK SORT -- \(quickSort)")
        print("-- QUICK SORT RW -- \(quickSortRW)")
        
        let matrixForPeakFinding = [[0,  0,  9,  0,  0,  0,  0],
            [0,  0,  0,  0,  0,  0,  0],
            [0,  1,  0,  0,  0,  0,  0],
            [0,  2,  0,  0,  0,  0,  0],
            [0,  3,  0,  0,  0,  0,  0],
            [0,  5,  0,  0,  0,  0,  0],
            [0,  4,  7,  0,  0,  0,  0]]
        
        var right = -1 //inout params
        var left = 0
        let peak = Algorithmator.findPeak(matrix: matrixForPeakFinding, left: &left, right: &right)
        let contains = Algorithmator.searchMatrixForValue(matrix: matrixForPeakFinding, target: 2)
        
        print("-- PEAK -- \(peak)")
        print("-- CONTAINS -- \(contains)")
        
        let asteroidArrOne = Algorithmator.asteroidCollision([5,10,-5])
        let asteroidArrTwo = Algorithmator.asteroidCollision([8,-8])
        let asteroidArrThree = Algorithmator.asteroidCollision([10,2,-5])
        
        print("ASTEROIDS \(asteroidArrOne) \(asteroidArrTwo) \(asteroidArrThree)")
        
        //MARK: This crashes, fix
        //let ms = Algorithmator.maximalSquare([["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]])
        
        //print("MAX SQUARE \(ms)")
        
        var theMatrix = [[1,2,3], [4,5,6], [7,8,9]]
        
        //Add return type
        Algorithmator.rotate(&theMatrix)
        
//        Cannot use mutating member on immutable value of type '[Int]'
        
//        let arrRemovalExtension = [1, 2, 3, 4].removeElements([3, 4])
//        print("ARR REMOVAL EXTENSION RESULT \(arrRemovalExtension)")
        
        
        //calculatorWrapper()
    }
    
    fileprivate func validParenthesisWrapper() {
        let firstVP = Algorithmator.isValid("({{{{}}}))")
        let secondVP = Algorithmator.isValid("[](){}")
        let thirdVP = Algorithmator.isValid("{[]}")
        let fourthVP = Algorithmator.isValid("()")
        let fifthVP = Algorithmator.isValid("({[)")
        
        print("VP Result \(firstVP) \(secondVP) \(thirdVP) \(fourthVP) \(fifthVP)")
    }
    
    //TODO: wrap others (don't crowd lifecyc=le functions)
    fileprivate func calculatorWrapper() {
        let solutionCalculatorOne = Algorithmator.calculate("3+2*2")
        let solutionCalculatorTwo = Algorithmator.calculate(" 3/2 ")
        let solutionCalculatorThree = Algorithmator.calculate(" 3+5 / 2 ")
        
        print("-- CALCULATOR SOLUTIONS \(solutionCalculatorOne) -- \(solutionCalculatorTwo) -- \(solutionCalculatorThree) --")
        
        //print("-- CALCULATOR SOLUTIONS \(solutionCalculatorOne) --")
    }
    
    fileprivate func UIConfig() {
        let vw = self.view.frame.size.width
        let vh = self.view.frame.size.height
        
        view.addSubview(scrollPicker)
        scrollPicker.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: vw - 40, height: vh / 5)
        scrollPicker.delegate = self
        
        scrollPicker.layer.borderWidth = 1
        scrollPicker.layer.borderColor = UIColor.black.cgColor
        scrollPicker.layer.masksToBounds = true
        scrollPicker.layer.cornerRadius = 5
        
        perform(#selector(scrollSetupWrapper), with: nil, afterDelay: 0.25)
        
        collectionSetup()
        containersSetup()
        
        //calculatorSetup() //Not offscreen yet, just UI test
    }
    
    //MARK: Graph / Strings subviews etc.
    fileprivate func containersSetup() {
        let vw = self.view.frame.size.width
        let vh = self.view.frame.size.height
        graphRenderer.frame = CGRect(x: -vw, y: vh / 3.5, width: vw - 40, height: vh / 2)
        originalGraphFrame = graphRenderer.frame
        view.addSubview(graphRenderer)
        
        addShadow(graphRenderer, color: .gray)
    }
    
    fileprivate func collectionSetup() {
        let vw = self.view.frame.size.width
        let vh = self.view.frame.size.height
        
        collection.frame = CGRect(x: 20, y: vh / 3.5, width: vw - 40, height: vh / 2)
        view.addSubview(collection)
        
        //MARK: This works but won't animate w/o animating constraints
        
//        collection.anchor(top: scrollPicker.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: vw - 40, height: vh / 2)
        
        originalCVFrame = collection.frame
        
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(AlgorithmCollectionCell.self, forCellWithReuseIdentifier: "aCell")
        
        addShadow(collection, color: .gray)
    }
    
    fileprivate func calculatorSetup() {
        let vw = self.view.frame.size.width
        let vh = self.view.frame.size.height
        
        calculatorRenderer.frame = CGRect(x: 20, y: vh / 3.5, width: vw - 40, height: vh / 2)
        view.addSubview(calculatorRenderer)
        
        //Extension
        calculatorRenderer.layer.shadowOffset = CGSize(width: 10,
                                                 height: 10)
        calculatorRenderer.layer.shadowRadius = 5
        calculatorRenderer.layer.shadowOpacity = 0.3
        calculatorRenderer.customShadowPath(shadowHeight: 5)
    }
    
    //Adding shadows is generally expensive. You can either rasterize (convert to pixels then display) or use shadowPath. Rasterizing can be the better option provided your view isn't dynamic (changing size or moving).
    
    fileprivate func addShadow(_ view: UIView, color: UIColor) {
        let layer = view.layer
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.5 //alpha
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shouldRasterize = false //rasterize means convert image into pixels (bitmap)
    }
    
    
    //On init frame is 0,0, wait a quarter of a second to set up
    @objc fileprivate func scrollSetupWrapper() {
        scrollPicker.setupScroll()
    }
    
    //MARK: Scroll index changed (header)
    func indexDidChange(index: Int) {
        configureNewUIForIndex(index)
    }
    
    func viewTappedAtIndex(index: Int, withName: String) {
        print("INDEX OF TAPPED VIEW \(index)")
        
        if withName == "Binary Search" {
            algorithmType = .binarySearch
            self.presentSubview(true)
        }

        if withName == "Peak Finder" {
            algorithmType = .peakFinder
            collectionMover(!collectionOffscreen)
            
            //Get rid of Binary (and others) view
            self.presentSubview(false)
        }
        
        if withName != "Peak Finder" {
            if !collectionOffscreen {
                collectionMover(true)
            }
        }
    }
    
    fileprivate func collectionMover(_ moveOffscreen: Bool) {
        if self.animationType == .collection {
            return
        }
        
        self.animationType = .collection
        UIView.animate(withDuration: 0.1) {
            let xCoord = moveOffscreen == true ? self.collection.frame.size.width : self.originalCVFrame.origin.x
            let x = moveOffscreen == true ? -xCoord : xCoord
            
            self.collection.frame = CGRect(x: x, y: self.originalCVFrame.origin.y, width: self.originalCVFrame.size.width, height: self.originalCVFrame.size.height)
            
        } completion: { complete in
            self.animationType = .none
            self.collectionOffscreen = !self.collectionOffscreen
            
            self.peakFinderWrapper()
        }
    }
    
    //TODO, this needs to pop back when collection goes on screen
    
    fileprivate func presentSubview(_ bs: Bool) {
        if self.animationType == .graphView { //Should use a different boolean?
            return
        }
        if bs == true {
            self.animationType = .graphView
            UIView.animate(withDuration: 0.1) {
                if self.graphRenderer.frame == self.originalGraphFrame {
                    //Move onscreen
                    self.graphRenderer.frame = CGRect(x: 20, y: self.originalGraphFrame.origin.y, width: self.originalGraphFrame.size.width, height: self.originalGraphFrame.size.height)
                    
                    self.sameInOrderTraversal()
                } else {
                    //Move offscreen
                    self.graphRenderer.frame = self.originalGraphFrame
                }
            } completion: { complete in
                self.animationType = .none
            }
        } else {
            //Strings or whatever ?
        }
    }
    
    fileprivate func peakFinderWrapper() {
        //TODO pass as parameter when input is configured
        let matrixForPeakFinding = [[0,  0,  9,  0,  0,  0,  0],
            [0,  0,  0,  0,  0,  0,  0],
            [0,  1,  0,  0,  0,  0,  0],
            [0,  2,  0,  0,  0,  0,  0],
            [0,  3,  0,  0,  0,  0,  0],
            [0,  5,  0,  0,  0,  0,  0],
            [0,  4,  7,  0,  0,  0,  0]]
        
        //TODO flatten this here
        self.collectionViewPopulatorMatrix = matrixForPeakFinding
        reloadCollectionOnMainQueue() // render initial matrix, notifications will control which are highlighted, should probably send back data all at once
        
        var right = -1 //inout params
        var left = 0
        let peak = Algorithmator.findPeak(matrix: matrixForPeakFinding, left: &left, right: &right)

        print("-- PEAK -- \(peak)")
    }
    
    fileprivate func configureNewUIForIndex(_ index: Int) {
        
    }
    
    fileprivate func addObserverForKeyPath(_ path: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(collectionDataFromAlgorithmator(_:)), name: Notification.Name(kNotificationNameAlgorithmDataUpdated), object: nil)
    }
    
    //Can also add Combine framework's version, i.e. Publishers + Subjects
    @objc fileprivate func collectionDataFromAlgorithmator(_ notif: Notification) {
        print("Observed data \(notif.userInfo)")
        //Do stuff with payload here (i.e. animate peak finder / strings etc)
    }
    
    //MARK: This works beautifully but allow user to build their own trees via input
    
    //MARK: Comparing inorder traversal of two binary trees
    
    fileprivate func sameInOrderTraversal() {
        
        //MARK: Time O(n+m)
        //MARK: Space O(n+m)
        
        let treeOne = TreeNode(5) //root
        treeOne.left = TreeNode(3)
        treeOne.left?.left = TreeNode(1)
        treeOne.right = TreeNode(7)
        treeOne.right?.left = TreeNode(6)
        
        print("TREE ONE \(treeOne)")
        
        let treeTwo = TreeNode(3) //root
        treeTwo.left = TreeNode(1)
        treeTwo.right = TreeNode(6)
        treeTwo.right?.left = TreeNode(5)
        treeTwo.right?.right = TreeNode(7)
        
        print("TREE TWO \(treeTwo)")
        
        //Store in one list, compare with another
        var listOne : [Int] = []
        
        inorder(treeOne, list: &listOne)

        let equalTrees = inorderCheckWrapper(treeTwo, list: &listOne)
        print("EQUAL TREES \(equalTrees)")
        
        //MARK: Compare
        //graphRenderer.setUpTreesToRenderAndCompare(treeOne, treeTwo)
        
        //MARK: Show one tree then rotate
        graphRenderer.setUpTreeToRender(treeOne)
    }
    
    //MARK: Can move these
    func inorderCheckWrapper(_ root: TreeNode?, list: inout [Int]) -> Bool {
        return inorderCheck(root, list: &list) && list.isEmpty
    }
    
    func inorder(_ root: TreeNode?, list: inout [Int]) {
        guard let theRoot = root else {
            return
        }
        inorder(theRoot.left, list: &list)
        list.append(theRoot.val)
        inorder(theRoot.right, list: &list)
    }
    
    func inorderCheck(_ root: TreeNode?, list: inout [Int]) -> Bool {
        guard let theRoot = root else {
            return true
        }
        
        if inorderCheck(theRoot.left, list: &list) == false {
            return false
        }
        if list.isEmpty == true || list[0] != theRoot.val {
            return false
        }
        list.remove(at: 0)
        
        return inorderCheck(theRoot.right, list: &list)
    }
    
    fileprivate func reloadCollectionOnMainQueue() {
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Should have "isObserving" boolean just in case
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: TODO external DS for cleaner code
typealias CollectionViewFunctions = UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension ViewController : CollectionViewFunctions {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var returnNumber = 1
        if algorithmType == .peakFinder {
            returnNumber = collectionViewPopulatorMatrix.count // # of total subarrays arrays
        }
        return returnNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnNumber = 0
        if algorithmType == .peakFinder {
            returnNumber = collectionViewPopulatorMatrix[section].count // subarray at index
        }
        return returnNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "aCell", for: indexPath) as? AlgorithmCollectionCell else {
            //Use this function to stop the program when control flow can only reach the call if your API was improperly used.
            
            preconditionFailure("No cell!")
        }
        
        if algorithmType == .peakFinder {
            if animationType == .none {
                let arrayAtSection = self.collectionViewPopulatorMatrix[indexPath.section]
                let val = arrayAtSection[indexPath.row]
                collectionCell.populateLabel("\(val)")
            } else {
                //animate algorithm
            }
        }
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = collectionViewPopulatorMatrix[0].count //size to subarray
        let theSize = self.collection.frame.size.width / CGFloat(dimension)
        return CGSize(width: theSize - 10, height: theSize - 10)
    }
}

