//
//  StringFunctionsRenderer.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 2/24/22.
//

import UIKit

class StringFunctionsRenderer: UIView {
    
    var labelArray: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    fileprivate func viewSetup() {
        
    }
    
    //No algorithm logic here, just displaying
    //TODO: Adjust width of labels to fit screen, i.e. fit really long word
    
    //MARK: Flow: This needs to animate slowly onto the screen
    func palindromeChecker(_ charString: String) {
        let arrCount = labelArray.count
        let xCoordOperand = (arrCount * 30) + (arrCount * 10)
        
        //TODO center
        let leftPadding = self.frame.size.width - CGFloat(xCoordOperand)
        let finalXCoord = (leftPadding / 2) - 30
        
        let labelToAdd = UILabel(frame: CGRect(x: finalXCoord, y: 50, width: 30, height: 30))
        labelToAdd.text = charString
        
        labelArray.append(labelToAdd)
        self.addSubview(labelToAdd)
    }
    
    fileprivate func clearViewArray() {
        labelArray.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
