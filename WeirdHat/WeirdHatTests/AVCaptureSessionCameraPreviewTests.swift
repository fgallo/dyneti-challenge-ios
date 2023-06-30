//
//  Created by Fernando Gallo on 30/06/23.
//

import XCTest
import AVFoundation
@testable import WeirdHat

final class AVCaptureSessionCameraPreviewTests: XCTestCase {

    func test_init_doesNotStartRunning() {
        let sut = makeSUT()
        
        XCTAssertFalse(sut.captureSession.isRunning)
    }
    
    func test_init_doesNotHaveInputsAndOutputs() {
        let sut = makeSUT()
        
        XCTAssertTrue(sut.captureSession.inputs.isEmpty)
        XCTAssertTrue(sut.captureSession.outputs.isEmpty)
    }
    
    func test_flipCamera_shouldStartFlippedAndThenFlipToBackCamera() {
        let sut = makeSUT()
        XCTAssertTrue(sut.isFlipped, "Should start flipped with front camera.")
        
        try? sut.flipCamera()
        XCTAssertFalse(sut.isFlipped, "Should flip to back camera.")
        
        try? sut.flipCamera()
        XCTAssertTrue(sut.isFlipped, "Should flip to front camera.")
    }
    
    func test_start_shouldStartRunning() {
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for completion")
        sut.start {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertTrue(sut.captureSession.isRunning)
    }
    
    func test_start_shouldStopRunning() {
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for completion")
        sut.start {
            sut.stop {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertFalse(sut.captureSession.isRunning)
    }
    
    func test_configure_hasInputAndOutput() {
        let sut = makeSUT()
        
        try? sut.configureInputAndOutput()
        
        XCTAssertFalse(sut.captureSession.inputs.isEmpty)
        XCTAssertFalse(sut.captureSession.outputs.isEmpty)
    }
    
    // MARK: - Helpers
    
    func makeSUT(position: AVCaptureDevice.Position = .front) -> AVCaptureSessionCameraPreview {
        return AVCaptureSessionCameraPreview(position: position)
    }

}
