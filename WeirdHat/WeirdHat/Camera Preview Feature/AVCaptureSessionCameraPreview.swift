//
//  Created by Fernando Gallo on 29/06/23.
//

import Foundation
import AVFoundation

final class AVCaptureSessionCameraPreview {
    private let captureSession: AVCaptureSession
    private let deviceTypes: [AVCaptureDevice.DeviceType]
    private var position: AVCaptureDevice.Position
    
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
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
    
    func start() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stop() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.stopRunning()
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
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        } else {
            throw NSError(domain: "Error when adding output.", code: 0)
        }
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
