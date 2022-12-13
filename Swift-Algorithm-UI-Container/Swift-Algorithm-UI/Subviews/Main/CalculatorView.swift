//
//  CalculatorView.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 12/5/22.
//

//import Foundation //For classes that don't use UIKit
import UIKit

class CalculatorView: UIView {
    
    //TODO, render / move others down
    var inputTextView : UITextView {
        let txt = UITextView()
        return txt
    }
    
    var buttonArray : [CalculatorButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        observe()
        perform(#selector(setUpArray), with: nil, afterDelay: 0.25)
        backgroundColor = .black
    }
    
    @objc fileprivate func setUpArray() {
        //Set up right stack (operands)
        
        //Could do UICollectionView here, but it's maybe more versatile this way
        var x = CGFloat(5)
        var y = CGFloat(5)
        let buttonWidth = (self.frame.size.width / 4) - 25
        
        buttonArray.removeAll()
        
        for i in 0..<buttonTexts().count {
            let text = buttonTexts()[i]
            
            //Doesn't really matter here but initializer with type double parameters may be better (doubles are more percise than floats, though floats will save memory)
            let buttonFrame = CGRect(x: x, y: y, width: buttonWidth, height: buttonWidth)
            let button = CalculatorButton(frame: buttonFrame)
            button.layer.cornerRadius = buttonWidth / 2
            button.layer.masksToBounds = true
            button.displayString = text
            
            //TODO Add tap / gesture
            addSubview(button)
            buttonArray.append(button)
            
            //Every four reset x back to 0, every four, increment y
            x += CGFloat(Int(buttonWidth) + 5)
            if i == 3 || i == 7 || i == 11 {
                x = 5
                y += (buttonWidth + 5)
            }
        }
    }
    
    fileprivate func observe() {
        let name = NSNotification.Name(rawValue: kNotificationNameCalculatorAlgorithmUpdated)
        NotificationCenter.default.addObserver(self, selector: #selector(highlightButtonsAtIndex(_:)), name: name, object: nil)
    }
    
    fileprivate func buttonTexts() -> [String] {
        return ["1", "2", "3", "+",
                "4", "5", "6", "-",
                "7", "8", "9", "*",
                "0", "AC", "/"] //TODO AC button will be double width
    }
    
    //TODO lock this so it must finish before
    @objc fileprivate func highlightButtonsAtIndex(_ notif: Notification) {
        let dict = notif.userInfo
        print("NOTIF DATA \(dict)")
    }
    
    deinit {
        removeObserver(self, forKeyPath: kNotificationNameCalculatorAlgorithmUpdated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
