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
        self.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    func setUpTreeToRender(_ rootNode: TreeNode?) {
        renderTreeAfterSetup(rootNode)
    }
    
    //MARK: Should ideally compare trees in subcontainers but for now this should do
    func setUpTreesToRenderAndCompare(_ rootNodeLeftTree: TreeNode?, _ rootNodeRightTree: TreeNode?) {
        renderDoubleTreesAfterSetup(rootNodeLeftTree, rootNodeRightTree)
    }
    
    //MARK: TODO, determine height, and create coordinates from there
    
    //MARK: Single tree
    func renderTreeAfterSetup(_ rootNode: TreeNode?) {
        
    }
    
    //MARK: Double Trees
    func renderDoubleTreesAfterSetup(_ rootNodeLeftTree: TreeNode?, _ rootNodeRightTree: TreeNode?) {
        
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

        addSubview(leftNodeView)
        addSubview(rightNodeView)
        
        //MARK: Recursion after roots showing for rest of nodes
        
        beginRecursiveSetupWithRoot(rootNodeLeftTree, parentUI: leftNodeView)
        beginRecursiveSetupWithRoot(rootNodeRightTree, parentUI: rightNodeView)
    }
    
    func beginRecursiveSetupWithRoot(_ parent: TreeNode?, parentUI: NodeView?) {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
