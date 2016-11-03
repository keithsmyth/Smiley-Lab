//
//  ViewController.swift
//  Smiley Lab
//
//  Created by Keith Smyth on 2/11/2016.
//  Copyright © 2016 Keith Smyth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var trayStartPoint: CGPoint!
    let trayOpenY: CGFloat = 585.0
    var trayCloseY: CGFloat = 723.0
    var imageStartTransform: CGAffineTransform!
    
    var newlyCreatedFace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayView.center.y = trayCloseY
    }

    @IBAction func onTrayPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let velocity = panGestureRecognizer.velocity(in: view)
        
        if panGestureRecognizer.state == .began {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20, options: .curveEaseInOut, animations: {
                self.trayView.center.y = velocity.y < 0 ? self.trayOpenY : self.trayCloseY
                }, completion: nil)
        }
    }
    
    @IBAction func onTrayTapGesture(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20, options: .curveEaseInOut, animations: {
            self.trayView.center.y = self.trayView.center.y == self.trayOpenY ? self.trayCloseY : self.trayOpenY
            }, completion: nil)
        
    }
    
    @IBAction func onFacePanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .began {
            // Gesture recognizers know the view they are attached to
            let imageView = panGestureRecognizer.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.isUserInteractionEnabled = true
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onNewFacePanGestureRecognizer(_:)))
            newlyCreatedFace.addGestureRecognizer(panGesture)
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(onNewFacePinchGesture(_:)))
            newlyCreatedFace.addGestureRecognizer(pinchGesture)
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
        } else if panGestureRecognizer.state == .changed {
            newlyCreatedFace.center = panGestureRecognizer.location(in: view)
        }
    }
    
    func onNewFacePanGestureRecognizer(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let imageView = panGestureRecognizer.view as! UIImageView
        switch panGestureRecognizer.state {
        case .began:
            imageStartTransform = imageView.transform
        case .changed:
            let translation = panGestureRecognizer.translation(in: view)
            imageView.transform = CGAffineTransform(scaleX: -translation.y / 3, y: -translation.y / 3)
        case .ended:
            imageView.transform = imageStartTransform
        default:
            break
        }
    }
    
    func onNewFacePinchGesture(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        print("pinch!")
    }
}

