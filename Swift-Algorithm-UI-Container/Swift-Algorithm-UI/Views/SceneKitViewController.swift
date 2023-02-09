//
//  SceneKitViewController.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 2/9/23.
//

import UIKit

class SceneKitViewController: UIViewController {

    var skContainer : SceneKitView = {
        let skc = SceneKitView()
        return skc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    fileprivate func configure() {
        skContainer.frame = CGRect(x: 20, y: 100, width: view.viewWidth(40, plus: 0, shrink: true), height: view.viewHeight(400, plus: 0, shrink: true))
        view.addSubview(skContainer)
        skContainer.configureScene()
        
        let cuboids = [[7,11,17],[7,17,11],[11,7,17],[11,17,7],[17,7,11],[17,11,7]] //102
        let maxStackedHeight = skContainer.maxHeight(cuboids)
        print("MSH SK \(maxStackedHeight)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
