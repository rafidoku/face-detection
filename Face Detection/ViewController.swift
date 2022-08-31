//
//  ViewController.swift
//  Face Detection
//
//  Created by Rafi Mochamad Fahreza on 25/08/22.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var captureView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        accuracyLabel.text = "Scanning . . ."
        let captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }

}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: CIImage(cvImageBuffer: pixelBuffer))
        let imageSize = CVImageBufferGetDisplaySize(pixelBuffer)
        var actualRect = CGRect()
        if let faces = faces {
            for face in faces {
                actualRect = CGRect(x: face.bounds.origin.x, y: imageSize.height - face.bounds.origin.y - face.bounds.height, width: face.bounds.width, height: face.bounds.height)
                print(actualRect)
                
            }
            DispatchQueue.main.async {
                let bound = UIView(frame: actualRect)
                bound.backgroundColor = .yellow
                self.view.addSubview(bound)
            }
        }
//        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
//            return
//        }
//        var identifier = VNClassificationObservation()
//        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
//
//            guard let results = finishedReq.results as? [VNClassificationObservation] else {
//                return
//            }
//
//            guard let firstObservation = results.first else {
//                return
//            }
//            DispatchQueue.main.async {
//                self.accuracyLabel.text = "\(firstObservation.identifier), \(firstObservation.confidence)"
//            }
//
//        }
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
