//
//  ArrayFunctionsRenderer.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 3/9/22.
//

import UIKit

enum ActionType {
    case highlightMiddle
    case highlightLeftRight
    case highlightAtIndex
    case compareValues
    case swapValues
}

class ArrayFunctionsRenderer: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //TODO subclass + stylize
    var viewArray : [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func clear() {
        viewArray.removeAll()
        //Remove subviews too
    }

    //MARK:
    func setUpWithArray(_ algorithmType: AlgorithmType, array: [Int]) {
        switch algorithmType {
        case .binarySearch:
            print("BS")
        case .mergeSort:
            mergeSortSetup(array: array)
        case .peakFinder:
            print("BS")
        case .buildingsArray:
            print("BS")
        case .autoComplete:
            print("BS")
        }
    }
    
    //Initial array setup, pre-animation
    func mergeSortSetup(array: [Int]) {
        
        //MARK: Hardcoded for test but eventually size according to array count (i.e. more items -> smaller views)
        var x = 10
        for i in 0...array.count - 1 {
            let label = UILabel(frame: CGRect(x: x, y: 20, width: 20, height: 20))
            label.tag = i
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
            label.text = "\(array[i])"
            viewArray.append(label)
            addSubview(label)
            x += 30
        }
    }
    
    //When array is set, animate ala merge sort
    func actionTime(_ actionType: ActionType, payload: [String: Any]) {
        if viewArray.count == 0 {
            return
        }
        
//        switch actionType {
//        case .highlightMiddle:
//
//        case .highlightLeftRight:
//
//        case .highlightAtIndex:
//
//        case .compareValues:
//
//        case .swapValues:
//
//        }
    }
    
    //MARK: Mergesort UI
    fileprivate func highlightMiddleOfArray(_ midpoint: Int, array: [Int]) {
        
    }
    
    fileprivate func highlightleftAndRight(_ left: [Int], right: [Int], array: [Int]) {
        
    }
    
    fileprivate func highlightAtIndex(_ index: Int, array: [Int]) {
        
    }
    
    fileprivate func compareValues(_ leftVal: Int, rightVal: Int, array: [Int]) {
        
    }
    
    fileprivate func swapValues(_ leftStartIndex: Int, rightStartIndex: Int, leftDestinationIndex: Int, rightDestinationIndex: Int, array: [Int]) {
        
    }
}
