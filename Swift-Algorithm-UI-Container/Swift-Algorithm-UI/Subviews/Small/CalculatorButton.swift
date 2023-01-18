//
//  CalculatorButton.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 12/12/22.
//

import UIKit

class CalculatorButton : UIView {
    
    var shouldHighlight = false {
        didSet {
            changeAlpha()
        }
    }
    
    var displayString = "" {
        didSet {
            configureLabel()
        }
    }
    
    //For numbers + symbols
    //Computed property (uninitliazed)
    
//    var displayLabel : UILabel {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.textColor = .white
//        return label
//    }
    
    //Computed property (initliazed)
    var displayLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    fileprivate func changeAlpha() {
        UIView.animate(withDuration: 0.25) {
            self.displayLabel.alpha = 0.5
        } completion: { finished in
            self.displayLabel.alpha = 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //perform(#selector(configureLabel), with: nil, afterDelay: 0.25)
    }
    
    @objc fileprivate func configureLabel() {
        displayLabel.frame = self.bounds
        displayLabel.text = displayString
        displayLabel.backgroundColor = displayString.isOperator() == true ? .orange : .darkGray
        addSubview(displayLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func isOperator() -> Bool {
        return self == "+" || self == "-" || self == "*" || self == "/"
    }
}
