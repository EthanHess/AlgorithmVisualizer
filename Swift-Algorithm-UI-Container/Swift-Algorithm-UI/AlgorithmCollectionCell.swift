//
//  AlgorithmCollectionCell.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 2/18/22.
//

import UIKit

class AlgorithmCollectionCell: UICollectionViewCell {
    
    var valueLabel : UILabel = {
        let vl = UILabel()
        return vl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(valueLabel)
        valueLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
        
    }
    
    func populateLabel(_ str: String) {
        valueLabel.text = str
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.text = ""
    }
}
