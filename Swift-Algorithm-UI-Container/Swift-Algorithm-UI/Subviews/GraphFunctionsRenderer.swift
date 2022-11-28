//
//  GraphFunctionsRenderer.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 2/24/22.
//

import UIKit

class GraphFunctionsRenderer: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var nodeArray : [NodeView] = []
    
    //(Binary) Tree, inorder / cyclic graph where each node has no more than two direct children
    var isTree = true {
        didSet {
            print("isTree set")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //MARK: Whatever is needed for init
        //self.backgroundColor = .systemGreen
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
//        self.backgroundColor = .darkGray
    }
    
    //MARK: Should ideally compare trees in subcontainers but for now this should do
    func setUpTreesToRenderAndCompare(_ rootNodeLeftTree: TreeNode?, _ rootNodeRightTree: TreeNode?) {
        renderDoubleTreesAfterSetup(rootNodeLeftTree, rootNodeRightTree)
    }
    
    //MARK: TODO, determine height, and create coordinates from there
    
    
    //MARK: Double Trees
    fileprivate func renderDoubleTreesAfterSetup(_ rootNodeLeftTree: TreeNode?, _ rootNodeRightTree: TreeNode?) {
        
        guard let rnlt = rootNodeLeftTree else {
            return
        }
        guard let rnrt = rootNodeRightTree else {
            return
        }
        
        let leftTreeHeight = determineTreeHeight(rnlt)
        let rightTreeHeight = determineTreeHeight(rnrt)
        
        print("TREE HEIGHTS LEFT \(leftTreeHeight) --- RIGHT \(rightTreeHeight)")
        
        let leftNodeView = NodeView(frame: nodeFrameWithTreeHeightDoubleTree(leftTreeHeight, leftTree: true))
        let rightNodeView = NodeView(frame: nodeFrameWithTreeHeightDoubleTree(rightTreeHeight, leftTree: false))
        
        leftNodeView.setValueText("\(rootNodeLeftTree?.val ?? 0)")
        rightNodeView.setValueText("\(rootNodeRightTree?.val ?? 0)")

        addSubview(leftNodeView)
        addSubview(rightNodeView)
        
        bringSubviewToFront(leftNodeView)
        bringSubviewToFront(rightNodeView)
        
        //MARK: Recursion after roots showing for rest of nodes
        
        beginRecursiveSetupWithRoot(rootNodeLeftTree, parentUI: leftNodeView)
        beginRecursiveSetupWithRoot(rootNodeRightTree, parentUI: rightNodeView)
    }
    
    fileprivate func beginRecursiveSetupWithRoot(_ parent: TreeNode?, parentUI: NodeView?) {
        guard let parentNode = parent else {
            return
        }
        
        //MARK: For consistency sake the child node will be two node widths at a 45 degree angle left / right
        
        //Render new node and draw bezier path from parent
        
        if parentNode.left != nil {
            //Set up node at level
            let newNodeView = addChildNodeView(true, parentUI: parentUI!)
            //Recur
            newNodeView.setValueText("\(parent?.left?.val ?? 0)")
            addSubview(newNodeView)
            bringSubviewToFront(newNodeView)
            beginRecursiveSetupWithRoot(parentNode.left!, parentUI: newNodeView)
        }
        if parentNode.right != nil {
            let newNodeView = addChildNodeView(false, parentUI: parentUI!)
            newNodeView.setValueText("\(parent?.right?.val ?? 0)")
            addSubview(newNodeView)
            bringSubviewToFront(newNodeView)
            beginRecursiveSetupWithRoot(parentNode.right!, parentUI: newNodeView)
        }
    }
    
    fileprivate func addChildNodeView(_ left: Bool, parentUI: NodeView) -> NodeView {
        print("LEFT \(left)")
        let startPoint = parentUI.center
        let doubleNodeWidth = parentUI.frame.size.width * 2
        let newXCoord = left == true ? startPoint.x - doubleNodeWidth : startPoint.x + doubleNodeWidth
        let newFrame = CGRect(x: newXCoord, y: startPoint.y + doubleNodeWidth, width: parentUI.frame.size.width, height: parentUI.frame.size.width)
        let endPoint = newFrame.center
        
        //MARK: Path creation
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 1.0
            
        layer.addSublayer(shapeLayer)
        
        let newNodeView = NodeView(frame: newFrame)
        newNodeView.setLabelColor(.systemGreen)
        
        return newNodeView
    }
    
    //MARK: will want to determine height / width of the tree and configure tree accordingly to fit it in frame + have pinch zoom functionality
    
    fileprivate func nodeFrameWithTreeHeightDoubleTree(_ height: Int, leftTree: Bool) -> CGRect {
        //TODO imp.
        let vw = self.frame.size.width
        let xCoord = leftTree == true ? vw / 4 : (vw / 4) * 3
        return CGRect(x: xCoord, y: 10, width: 20, height: 20)
    }
    
    //MARK: O(n), n being number of nodes, best case scenario O(1) (one node)
    
    fileprivate func determineTreeHeight(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        }
        let leftHeight = determineTreeHeight(root?.left)
        let rightHeight = determineTreeHeight(root?.right)
        return max(leftHeight, rightHeight) + 1
    }
    
    
    //MARK: Rotate tree (single mode, not compare mode)
    
    func setUpTreeToRender(_ rootNode: TreeNode?) {
        renderTreeAfterSetup(rootNode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.rotateBinaryWrapper(rootNode)
        }
    }

    
    //Single tree
    fileprivate func renderTreeAfterSetup(_ rootNode: TreeNode?) {
        guard let tn = rootNode else {
            return
        }
        
        let treeHeight = determineTreeHeight(tn)
        
        print("TREE HEIGHT \(treeHeight)")
        
        let nodeView = NodeView(frame: nodeFrameWithTreeHeightDoubleTree(treeHeight, leftTree: true)) //For now we'll use the left tree for single but eventually center

        addSubview(nodeView)
        
        //MARK: Recursion after roots showing for rest of nodes
        beginRecursiveSetupWithRoot(rootNode, parentUI: nodeView)
    }
    
    fileprivate func rotateBinaryWrapper(_ root: TreeNode?) {
        let newRotatedTree = rotateBinaryTreeThenRerender(root)
        
        //MARK: Redraw view
        
        //Note, TODO just removing from superview, should store in array and clear, but for now we just want to see if rotation works
        
        //Remove Node views
        for theView in self.subviews {
            theView.removeFromSuperview()
        }
        
        //Remove bezier paths (layers) ?
        renderTreeAfterSetup(newRotatedTree)
    }
    
    fileprivate func rotateBinaryTreeThenRerender(_ root: TreeNode?) -> TreeNode? {
        if root == nil {
            return root
        }
        let noChildren = root?.left == nil && root?.right == nil
        if noChildren {
            return root
        }
        
        let rotatedRoot = rotateBinaryTreeThenRerender(root?.left)
        
        //MARK: Reassignment
        root?.left?.left = root?.right
        root?.left?.right = root
        //root?.left = root?.right = nil
        root?.left = nil
        root?.right = nil
        
        print("ROTATED ROOT \(rotatedRoot.logable)")
        return rotatedRoot
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: How to make that annoying warning about string interpolation optionals go away

//Credit
//https://stackoverflow.com/questions/42543007/how-to-solve-string-interpolation-produces-a-debug-description-for-an-optional

extension Optional {
    var logable: Any {
        switch self {
        case .none:
            return "<nil>|⭕️"
        case let .some(value):
            return value
        }
    }
}
