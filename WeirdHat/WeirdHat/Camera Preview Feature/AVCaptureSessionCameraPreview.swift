//
//  Created by Fernando Gallo on 29/06/23.
//

import Foundation
import AVFoundation

enum CameraPreviewSource {
    case back
    case front
}

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
    
    func setSource(_ source: CameraPreviewSource) {
        position = source.toPosition()
    }
    
    func configureInputAndOutput(completion: (Error?) -> Void) {
        removeInputAndOutput()
        addInput(completion: completion)
        addOutput(completion: completion)
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
    private func addInput(completion: (Error?) -> Void) {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes,
                                                            mediaType: .video,
                                                            position: position).devices.first,
              let input = try? AVCaptureDeviceInput(device: device) else {
            completion(NSError(domain: "Error when creating device input", code: 0))
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        } else {
            completion(NSError(domain: "Error when adding input", code: 0))
        }
    }
    
    private func removeInput() {
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
    }
    
    private func addOutput(completion: (Error?) -> Void) {
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        } else {
            completion(NSError(domain: "Error when adding output", code: 0))
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

extension CameraPreviewSource {
    func toPosition() -> AVCaptureDevice.Position {
        switch self {
        case .back: return AVCaptureDevice.Position.back
        case .front: return AVCaptureDevice.Position.front
        }
    }
}
