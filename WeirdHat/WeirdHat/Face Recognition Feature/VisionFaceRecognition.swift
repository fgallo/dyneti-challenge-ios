//
//  Created by Fernando Gallo on 29/06/23.
//

import Vision

class VisionFaceRecognition {
    static func detectFace(image: CVPixelBuffer, completion: @escaping (Result<[CGRect], Error>) -> Void) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { request, error in
            if let results = request.results as? [VNFaceObservation], !results.isEmpty {
                completion(.success(results.map { $0.boundingBox }))
            } else {
                let error = NSError(domain: "No faces recognized", code: 0)
                completion(.failure(error))
            }
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
}
