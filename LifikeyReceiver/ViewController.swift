//
//  ViewController.swift
//  LifikeyReceiver
//
//  Created by Hui-yu Lee on 5/26/16.
//  Copyright © 2016 iot. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {


    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    @IBOutlet weak var textView: UITextView!
    
    var captureSession : AVCaptureSession!
    var previewLayer : AVCaptureVideoPreviewLayer?
    var camera:AVCaptureDevice!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")

        setCaptureInput()

        addPreviewLayer()

        setVideoOutput()

        captureSession.startRunning()
        print("captureSession.startRunning()")

        //set framerate
        do {
            try camera.lockForConfiguration()
            camera.activeVideoMinFrameDuration = CMTimeMake(1, 30)
            camera.unlockForConfiguration()
        } catch _ {
        }
    }

    override func viewWillDisappear(animated: Bool) {
        captureSession.stopRunning()
        print("captureSession.stopRunning()")
    }

    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        print("viewDidLayoutSubviews")
    //        previewLayer?.frame = self.cameraPreviewView.bounds
    //    }
    
    // MARK: CaptureSession related functions
    func setCaptureInput() {
        print("setCaptureInput")
        captureSession = AVCaptureSession()
        
        for caputureDevice: AnyObject in AVCaptureDevice.devices() {
            //back camera
            if caputureDevice.position == AVCaptureDevicePosition.Back {
                camera = caputureDevice as? AVCaptureDevice
            }
            //front camera
            //            if caputureDevice.position == AVCaptureDevicePosition.Front {
            //                camera = caputureDevice as? AVCaptureDevice
            //            }
        }
        
        let error: NSError? = nil
        var input : AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: camera)
        } catch let error as NSError{
            print(error)
        }
        
        if error == nil && captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
    }
    
    func addPreviewLayer() {
        print("addPreviewLayer")
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = self.cameraPreviewView.bounds
        self.cameraPreviewView.layer.insertSublayer(previewLayer!, below: self.textView.layer)
    }
    
    func setVideoOutput() {
        print("setVideoOutput")
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)] //YUV, '420f'
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
        captureSession.addOutput(videoDataOutput)
    }
    
    
    // MARK: AVCaptureVideoSampleBufferOutputDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didDropSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        print("drop buffers")
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        print("output")
    }
    
}

