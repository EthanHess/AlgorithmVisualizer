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
    
    var sceneContainer : SCNView = {
        let theContainer = SCNView()
        return theContainer
    }() // = () initializes, W/O it's a computed property
    
    var scene : SCNScene = {
        let scene = SCNScene()
        return scene
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func configureScene() {
        
        // configure container
        sceneContainer.frame = CGRect(x: 10, y: 10, width: frame.size.width - 20, height: frame.size.height - 20)
        sceneContainer.layer.cornerRadius = 5
        self.layer.cornerRadius = 5
        addSubview(sceneContainer)
            
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
               
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
            
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
                
        // set the scene to the view
        sceneContainer.scene = scene
        
        // allows the user to manipulate the camera
        sceneContainer.allowsCameraControl = true
            
        // show statistics such as fps and timing information
        sceneContainer.showsStatistics = true
        
        // configure the view
        sceneContainer.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addInitialBoxesToScene(_ dimensionArray: [[Int]]) {
        //Start at bottom, build tower
        for dimensions in dimensionArray {
            //Assume exists (in this problem)
            let length = CGFloat(dimensions[0])
            let width = CGFloat(dimensions[1])
            let height = CGFloat(dimensions[2])
            
            let boxGeo = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
            let boxNode = SCNNode(geometry: boxGeo)
            boxGeo.firstMaterial?.diffuse.contents = UIColor.cyan
            
            scene.rootNode.addChildNode(boxNode)
        }
    }
    
    fileprivate func repositionBox() {
        //TODO imp.
    }
    
    //MARK: Algorithmator is getting crowded so we'll put this here for now
    func maxHeight(_ cuboids: [[Int]]) -> Int {
        
        addInitialBoxesToScene(cuboids) //render, then sort
        
        //Iterative approach
        //Subarray will contain [length, width, height]
        for var cuboid in cuboids {
            //Need to sort subarray (i.e. c[0] <= c[1] <= c[2])
            cuboid.sort()
            print("sorted cuboid dimensions \(cuboid)")
        }
    
        //After subarrays sorted, sort matrix
        
        
        //Current cuboid at bottom, get max height
        //[i][2] will be the height
        
        var depth : [Int] = []
        for i in 0..<cuboids.count {
            let depthToAdd = cuboids[i][2]
            depth.append(depthToAdd)
        }
        
        //Starting at 1 because
        for i in 1..<cuboids.count {
            for j in 0..<i {
                print("I \(i) J \(j)")
            }
        }
        
        guard let maxDepth = depth.max() else {
            return 0
        }
        
        return maxDepth
    }
}
