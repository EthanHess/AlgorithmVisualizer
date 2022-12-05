//
//  AlgorithmChoiceScroll.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 12/27/20.
//

import UIKit

protocol ScrollIndexDidChange : AnyObject {
    func indexDidChange(index: Int)
    func viewTappedAtIndex(index: Int, withName: String)
}

let titleKey = "title"
let colorKey = "color"

typealias ContentItem = [[String : Any]]

//MARK: Main choice scroll

class AlgorithmChoiceScroll: UIView, UIScrollViewDelegate {
    
    var scrollView : UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    var viewArray : [UIView] = []
    weak var delegate : ScrollIndexDidChange?
    
    //TODO custom colors
    //TODO add QuickSort
    fileprivate func algorithmArray() -> ContentItem {
        return [[titleKey: "Binary Search", colorKey: UIColor.blue], [titleKey: "Merge Sort", colorKey: UIColor.red], [titleKey: "Peak Finder", colorKey: UIColor.orange], [titleKey: "Buildings Array", colorKey: UIColor.systemTeal], [titleKey: "Autocomplete", colorKey: UIColor.systemGreen]]
    }
    
    func setupScroll() {
        //scroll
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: Int(self.bounds.size.width) * algorithmArray().count, height: 0)
        scrollView.isPagingEnabled = true
        self.addSubview(scrollView)
        
        //TODO page control?
        
        //content
        
        viewArray.removeAll()
        clearScrollView()
        
        var x = CGFloat(0.0)
        
        for i in 0..<algorithmArray().count {
            
            let height = CGFloat(self.frame.size.height - 20)
            let width = CGFloat(self.frame.size.width - 20)
            let frameForView = CGRect(x: x, y: CGFloat(10), width: width, height: height)
            let theLabel = UILabel(frame: frameForView)
            
            theLabel.layer.cornerRadius = 35
            theLabel.tag = i
            theLabel.isUserInteractionEnabled = true
            theLabel.textAlignment = .center
            
            theLabel.text = algorithmArray()[i][titleKey] as? String
            theLabel.textColor = (algorithmArray()[i][colorKey] as! UIColor)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(viewTappedAtIndex(sender:)))
            theLabel.addGestureRecognizer(tap)
            
            scrollView.addSubview(theLabel)
            
            x = x + width
        }
    }
    
    @objc func viewTappedAtIndex(sender: UIGestureRecognizer) {
        guard let viewTag = sender.view?.tag else {
            print("No tag")
            return
        }
        let name = algorithmArray()[viewTag][titleKey]
        self.delegate?.viewTappedAtIndex(index: viewTag, withName: name as! String)
    }
    
    //Prevents duplication
    fileprivate func clearScrollView() {
        for theView in viewArray {
            theView.removeFromSuperview()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Animate according to offset coords here
        print("SCROLL OFFSET X \(scrollView.contentOffset.x)")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
