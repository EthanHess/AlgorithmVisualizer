//
//  NodeView.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 2/24/22.
//

import UIKit

class NodeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        valueLabel.frame = self.bounds
        addSubview(valueLabel)
        
        layer.cornerRadius = self.frame.size.width / 2
        layer.masksToBounds = true
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
    }
    
    func setLabelColor(_ theColor: UIColor) {
        valueLabel.backgroundColor = theColor
    }
    
    func setValueText(_ val: String) {
        valueLabel.text = val
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
