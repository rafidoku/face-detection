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

        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
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
        view.bringSubviewToFront(accuracyLabel)
        
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
            if faces.count == 0 {
                DispatchQueue.main.async {
                    actualRect = CGRect()
                    self.accuracyLabel.text = "Arahkan kamera ke wajah anda"
                }
            }
            for face in faces {
                actualRect = CGRect(x: face.bounds.origin.x, y: imageSize.height - face.bounds.origin.y - face.bounds.height, width: face.bounds.width, height: face.bounds.height)
                DispatchQueue.main.async {
                    self.accuracyLabel.text = "Wajah terdeteksi"
//                    let bound = UIView(frame: actualRect)
//                    bound.backgroundColor = .yellow
//                    self.captureView.addSubview(bound)
//                    self.captureView.bringSubviewToFront(bound)
                }
            }
        } else {
            self.accuracyLabel.text = "Arahkan kamera ke wajah anda"
        }
    }
}
