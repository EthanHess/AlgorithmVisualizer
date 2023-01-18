//
//  InputContainer.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 6/14/22.
//

import UIKit

enum InputType {
    case arrayFlat
    case arrayMatrix
    case string
    case none
}

class InputContainer: UIView {
    
    var animationType : InputType = .none
    
    var mainInput : UITextField = {
        let theInput = UITextField()
        theInput.borderStyle = .roundedRect
        return theInput
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selector = #selector(renderTextField)
        perform(selector, with: nil, afterDelay: 0.25)
    }
    
    @objc fileprivate func renderTextField() {
        //If we want to animage just use rect, it may make things easier
        addSubview(mainInput)
        mainInput.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
    }
    
    //Can have type toggle internally but for now will just do from outside / main VC
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
