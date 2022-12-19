//
//  SubChoiceScroll.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 12/5/22.
//

import UIKit

//MARK: To inject into subviews to choose between different types of graph / tree / string problems etc.

class SubChoiceScroll: UIView, UIScrollViewDelegate {
    
    var scrollView : UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    var viewArray : [UIView] = []
    
    var contentArray : ContentItem = [] {
        didSet {
            self.perform(#selector(setupScroll), with: nil, afterDelay: 0.25)
        }
    }
    
    weak var delegate : ScrollIndexDidChange?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @objc fileprivate func setupScroll() {
        //scroll
        scrollView.frame = self.bounds
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: Int(self.bounds.size.width) * contentArray.count, height: 0)
        scrollView.isPagingEnabled = true
        self.addSubview(scrollView)
        
        //TODO page control?
        
        //content
        
        viewArray.removeAll()
        clearScrollView()
        
        var x = CGFloat(0.0)
        
        for i in 0..<contentArray.count {
            
            let height = CGFloat(self.frame.size.height - 20)
            let width = CGFloat(self.frame.size.width - 20)
            let frameForView = CGRect(x: x, y: CGFloat(10), width: width, height: height)
            let theLabel = UILabel(frame: frameForView)
            
            theLabel.layer.cornerRadius = 35
            theLabel.tag = i
            theLabel.isUserInteractionEnabled = true
            theLabel.textAlignment = .center
            
            theLabel.text = contentArray[i][titleKey] as? String
            theLabel.textColor = (contentArray[i][colorKey] as! UIColor)
            
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
        let name = contentArray[viewTag][titleKey]
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
