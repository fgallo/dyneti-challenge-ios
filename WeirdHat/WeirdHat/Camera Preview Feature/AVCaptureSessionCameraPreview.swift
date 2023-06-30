//
//  Created by Fernando Gallo on 29/06/23.
//

import Foundation
import AVFoundation

final class AVCaptureSessionCameraPreview: NSObject {
    private let deviceTypes: [AVCaptureDevice.DeviceType]
    private var position: AVCaptureDevice.Position
    
    let captureSession: AVCaptureSession
    var lastImageBuffer: CVImageBuffer?
    var onImageCapture: ((CVImageBuffer) -> Void)?
    
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    var isFlipped: Bool {
        position == .front
    }
    
    init(position: AVCaptureDevice.Position = .front) {
        self.captureSession = AVCaptureSession()
        self.position = position
        self.deviceTypes = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
    }
    
    func flipCamera() throws {
        position = position == .back ? .front : .back
        try configureInputAndOutput()
    }
    
    func configureInputAndOutput() throws {
        removeInputAndOutput()
        try addInput()
        try addOutput()
    }
    
    func start(completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
            completion?()
        }
    }
    
    func stop(completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.stopRunning()
            completion?()
        }
    }
    
}


// MARK: - Helpers

extension AVCaptureSessionCameraPreview {
    private func addInput() throws {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes,
                                                            mediaType: .video,
                                                            position: position).devices.first,
              let input = try? AVCaptureDeviceInput(device: device) else {
            throw NSError(domain: "Error when creating device input.", code: 0)
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        } else {
            throw NSError(domain: "Error when adding input.", code: 0)
        }
    }
    
    private func removeInput() {
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
    }
    
    private func addOutput() throws {
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_processing_queue"))
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        } else {
            throw NSError(domain: "Error when adding output.", code: 0)
        }
        
        guard let connection = output.connection(with: .video), connection.isVideoOrientationSupported else {
            throw NSError(domain: "Error when adding output.", code: 0)
        }
        
        connection.videoOrientation = .portrait
    }
    
    private func removeOutput() {
        for output in captureSession.outputs {
            captureSession.removeOutput(output)
        }
    }
    
    private func removeInputAndOutput() {
        removeInput()
        removeOutput()
    }
}


// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension AVCaptureSessionCameraPreview: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        lastImageBuffer = imageBuffer
        
        onImageCapture?(imageBuffer)
    }
}
