//
//  RainwaterContainer.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 1/17/23.
//

import UIKit

//MARK: Attempted this on my own and used this StackOverflow link for some reference
//https://stackoverflow.com/questions/60762757/how-can-i-properly-animate-a-uibezierpath-to-have-a-water-wave-effect

class RainwaterContainer: UIView {
    
    //CADisplayLink = A timer object that allows your app to synchronize its drawing to the refresh rate of the display.
    
    weak var displayLink: CADisplayLink? //Will hold a strong reference to self? If so, needs to be weak to avoid retain cycle.
    
    //Amplitude = in physics, the maximum displacement or distance moved by a point on a vibrating body or wave measured from its equilibrium position.
    
    //Are marked private in example, probably don't want to access these externally (TODO)
    var startTime: CFTimeInterval = 0
    let maxAmplitude: CGFloat = 0.1
    let maxTidalVariation: CGFloat = 0.1
    let amplitudeOffset = CGFloat.random(in: -0.5 ... 0.5)
    let amplitudeChangeSpeedFactor = CGFloat.random(in: 4 ... 8)
    
    let defaultTidalHeight: CGFloat = 0.50
    let saveSpeedFactor = CGFloat.random(in: 4 ... 8)
    
    lazy var background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.addSublayer(shapeLayer)
        return background
    }()

    //TODO add whitecaps ;) (black diamond challenge)
    let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.blue.cgColor //water top
        shapeLayer.fillColor = UIColor.cyan.cgColor //water fill
        return shapeLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    func configureWithMode(_ gradient: Bool) {
        if gradient == true { //black background (or gradient eventually to make more realistic)
            backgroundColor = .black
            //configureGradient([])
        } else { //transparent background,
            backgroundColor = .clear
            configureBezier()
        }
    }
    
    fileprivate func configureBezier() {
        addSubview(background)
        background.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        startDisplayLink()
        
        //CGPath = The Core Graphics representation of the path. In this case it's of a UIBezierPath
        
        guard let thePath = wave(at: 0)?.cgPath else {
            print("No path RC")
            return
        }
        shapeLayer.path = thePath
    }
    
    //UIView API
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            stopDisplayLink() //is a timer
        }
    }
    
    
    //MARK: Half alpha / half image combination, does it look cool?
    
    fileprivate func configureGradient(_ colors: [CGColor]) {
        //TODO imp.
    }
    
    fileprivate func configureBackgroundImage(_ imagePath: String) {
        //imp.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension RainwaterContainer {
    func wave(at elapsed: Double) -> UIBezierPath? {
        guard bounds.width > 0, bounds.height > 0 else { return nil }

        func f(_ x: CGFloat) -> CGFloat {
            let elapsed = CGFloat(elapsed)
            let amplitude = maxAmplitude * abs(fmod(elapsed / 2, 3) - 1.5)
            let variation = sin((elapsed + amplitudeOffset) / amplitudeChangeSpeedFactor) * maxTidalVariation
            let value = sin((elapsed / saveSpeedFactor + x) * 4 * .pi)
            return value * amplitude / 2 * bounds.height + (defaultTidalHeight + variation) * bounds.height
        }

        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))

        let count = Int(bounds.width / 10)

        for step in 0 ... count {
            let dataPoint = CGFloat(step) / CGFloat(count)
            let x = dataPoint * bounds.width + bounds.minX
            let y = bounds.maxY - f(dataPoint)
            let point = CGPoint(x: x, y: y)
            path.addLine(to: point)
        }
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.close()
        return path
    }
    
    func startDisplayLink() {
        startTime = CACurrentMediaTime()
        displayLink?.invalidate()
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }

    func stopDisplayLink() {
        displayLink?.invalidate()
    }

    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        let elapsed = CACurrentMediaTime() - startTime
        //Should guard / check here if path could be nil
        guard let thePath = wave(at: elapsed)?.cgPath else {
            print("No path RC")
            return
        }
        shapeLayer.path = thePath
    }
}
