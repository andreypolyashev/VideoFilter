//
//  VideoFilterController.swift
//  LineMaker
//
//  Created by Mac-mini on 26.01.17.
//  Copyright © 2017 AndreyPolyashev. All rights reserved.
//

import UIKit
import AVFoundation

class VideoFilterController: UIViewController {

    //MARK: Private Properties
    @IBOutlet weak var bwImageView: UIImageView!
    @IBOutlet weak var coloredImageView: UIImageView!
    
    fileprivate let bufferQueue = DispatchQueue(label: "buffer Queue", attributes: .concurrent)
    
    fileprivate let session = AVCaptureSession()
    fileprivate let videoOutput = AVCaptureVideoDataOutput()
    fileprivate let affineHorizontalFlipped = CGAffineTransform(scaleX: -1.0, y: 1.0)
    
    fileprivate let filterManager: FilterManager
    
    //MARK: Lifecycle
    init(filters: [FilterType]) {
        filterManager = FilterManager(filters: filters)
        super.init(nibName: "VideoFilterController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: AVCaptureVideoDataOutputSampleBufferDelegate
extension VideoFilterController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
        connection.videoOrientation = .portrait
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)  else {
            return
        }
        
        let capturedImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        DispatchQueue.main.async {
            self.coloredImageView.image = UIImage(ciImage: capturedImage)
        }
        
        DispatchQueue.main.async {
            self.bwImageView.image = self.filterManager.imageWithFilter(.blackWhite, cameraImage: capturedImage)
        }
    }
}

//MARK: Supporting methods
extension VideoFilterController {
    func setup() {
        coloredImageView.transform = affineHorizontalFlipped
        coloredImageView.contentMode = .scaleAspectFill
        
        bwImageView.transform = affineHorizontalFlipped
        bwImageView.contentMode = .scaleAspectFill
        
        
        videoOutput.setSampleBufferDelegate(self, queue: bufferQueue)
        
        session.sessionPreset = AVCaptureSessionPresetPhoto
        if session.canAddOutput(videoOutput)  {
            session.addOutput(videoOutput)
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: getFrontCamera())
            session.addInput(input)
        } catch {
            print("Нету доступа к камере.")
            return
        }
        
        session.startRunning()
    }
    
    func getFrontCamera() -> AVCaptureDevice? {
        for device in  AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) {
            if let device = device as? AVCaptureDevice, device.position == .front {
                return device
            }
        }
        return nil
    }
}
