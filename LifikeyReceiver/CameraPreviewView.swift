//
//  CameraPreviewView.swift
//  LifikeyReceiver
//
//  Created by Hui-yu Lee on 6/2/16.
//  Copyright © 2016 iot. All rights reserved.
//

import UIKit
import AVFoundation

class CameraFocusSquare: UIView {
    
    internal let kSelectionAnimation:String = "selectionAnimation"
    private var _selectionBlink: CABasicAnimation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor.whiteColor().CGColor
        initBlink()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initBlink() {
        // create the blink animation
        self._selectionBlink = CABasicAnimation(keyPath: "borderColor")
        self._selectionBlink!.toValue = (UIColor.orangeColor().CGColor as AnyObject)
        self._selectionBlink!.repeatCount = 4
        // number of blinks
        self._selectionBlink!.duration = 0.4
        // this is duration per blink
        self._selectionBlink!.delegate = self
    }
    
    func animateFocus() {
        self.layer.addAnimation(self._selectionBlink!, forKey: kSelectionAnimation)
    }
    /**
     Hides the view after the animation stops. Since the animation is automatically removed, we don't need to do anything else here.
     */
    override func animationDidStop(animation: CAAnimation, finished flag: Bool) {
        // hide the view
        self.alpha = 0.0
        self.hidden = true
    }
}

class CameraPreviewView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var touchPoint = CGPoint(x: 0, y: 0)
    var camFocus: CameraFocusSquare? = nil
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        let touch: UITouch = touches.first as UITouch!
        touchPoint = touch.locationInView(touch.view)
        
        self.focus(touchPoint)

        if(camFocus != nil) {
            camFocus?.removeFromSuperview()
        }
        if ((touch.view?.isKindOfClass(CameraPreviewView)) != nil) {
            let frame = CGRectMake(touchPoint.x-40, touchPoint.y-40, 80, 80)
            
            camFocus = CameraFocusSquare.init(frame: frame)
            self.addSubview(camFocus!)
            camFocus?.setNeedsDisplay()
            camFocus!.animateFocus()
        }
        
    }
    
    func focus(aPoint: CGPoint) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let camera: AVCaptureDevice? = appDelegate.viewController!.camera
        let previewLayer: AVCaptureVideoPreviewLayer? = appDelegate.viewController!.previewLayer
        if (camera != nil) {
            let focusPoint: CGPoint = previewLayer!.captureDevicePointOfInterestForPoint(aPoint)
            //set focus            
            do {
                try camera!.lockForConfiguration()
                camera!.focusPointOfInterest = focusPoint
                print("focus " + String(focusPoint))
                camera!.focusMode = AVCaptureFocusMode.AutoFocus
                camera!.unlockForConfiguration()
            } catch _ {
            }
        }
        
    }
    

}
