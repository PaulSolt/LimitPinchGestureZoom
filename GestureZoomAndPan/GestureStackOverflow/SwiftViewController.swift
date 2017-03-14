//
//  SwiftViewController.swift
//  GestureZoomAndPan
//
//  Created by Aximem on 14/03/2017.
//  Copyright © 2017 Paul Solt. All rights reserved.
//

import Foundation
import UIKit

class SwiftViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        let blueView = UIView(frame: CGRect(x: 100, y: 100, width: 150, height: 150))
        blueView.backgroundColor = UIColor.blue
        self.view.addSubview(blueView)
        self.addMovementGesturesToView(view: blueView)
        
        let imageView = UIImageView(image: UIImage(named: "BombDodge.png"))
        imageView.center = CGPoint(x: 160, y: 250)
        imageView.sizeToFit()
        self.view.addSubview(imageView)
        self.addMovementGesturesToView(view: imageView)
        
        let label = UILabel()
        label.text = "Hello Gestures!"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = UIColor.black
        label.sizeToFit()
        label.center = CGPoint(x: 160, y: 400)
        self.view.addSubview(label)
        self.addMovementGesturesToView(view: label)
    }
    
    func addMovementGesturesToView(view: UIView) {
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(pinchGesture:)))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(rotateGesture:)))
        rotateGesture.delegate = self
        view.addGestureRecognizer(rotateGesture)
    }
    
    func handlePanGesture (panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: panGesture.view?.superview)
        if panGesture.state == .began || panGesture.state == .changed {
            panGesture.view?.center = CGPoint(x: (panGesture.view?.center.x)! + translation.x, y: (panGesture.view?.center.y)! + translation.y)
            panGesture.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    func handlePinchGesture (pinchGesture: UIPinchGestureRecognizer) {
        if pinchGesture.state == .began || pinchGesture.state == .changed {
            let currentScale: CGFloat = pinchGesture.view?.layer.value(forKeyPath: "transform.scale.x") as! CGFloat
            let minScale: CGFloat = 0.1
            let maxScale: CGFloat = 2.0
            let zoomSpeed: CGFloat = 0.5
            
            var deltaScale = pinchGesture.scale
            
            deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
            deltaScale = min(deltaScale, maxScale / currentScale)
            deltaScale = max(deltaScale, minScale / currentScale)
            
            let zoomTransform = (pinchGesture.view?.transform)!.scaledBy(x: deltaScale, y: deltaScale)
            pinchGesture.view?.transform = zoomTransform
            pinchGesture.scale = 1
        }
    }
    
    open func handleRotateGesture (rotateGesture: UIRotationGestureRecognizer) {
        if rotateGesture.state == .began || rotateGesture.state == .changed {
            rotateGesture.view?.transform = (rotateGesture.view?.transform)!.rotated(by: rotateGesture.rotation)
            rotateGesture.rotation = 0
        }
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
