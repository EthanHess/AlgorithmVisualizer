//
//  SceneKitView.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 12/5/22.
//

import UIKit
import SceneKit

//For box stacking algorithm etc. (or anything else that will have 3D rendering)
class SceneKitView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
