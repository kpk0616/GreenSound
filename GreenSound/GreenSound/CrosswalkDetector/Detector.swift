//
//  Detector.swift
//  GreenSound
//
//  Created by 박의서 on 2023/09/23.
//

import Vision
import AVFoundation
import UIKit

extension ViewController {
    
    
    
    func setupDetector() {
        let modelURL = Bundle.main.url(forResource: "CrosswalkAndTrafficlight", withExtension: "mlmodelc")
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            print(error)
        }
    }
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async(execute: {
            if let results = request.results {
                self.extractDetections(results)
            } else {
            }
        })
    }
    
    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil
        
        if results.isEmpty {
            print("물체 없음")
            emptyCount += 1
            // 횡단보도 이탈 감지
            if StatusManager.shared.status == .haveToDepart, emptyCount % 70 == 0 {
                StatusManager.shared.status = .leave
                StatusManager.shared.playSound("10_횡단보도이탈")
                emptyCount = 0
            }
        }
        
        for observation in results where observation is VNRecognizedObjectObservation {
            emptyCount = 0
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
          
            prevLabel = nowLabel
            print(objectObservation.labels.first?.identifier)
            detectorCounting(objectObservation)
            
            if StatusManager.shared.status == .finding, crossWalkDetedtedCount == 140 {
                print("횡단보도 10번 인식 후 재생")
                StatusManager.shared.updateStatus(to: .arrived)
                StatusManager.shared.playSound("05_횡단보도도착")
                crossWalkDetedtedCount = 0
            } else if crossWalkDetedtedCount == 140 {
                StatusManager.shared.status = .crossing
                StatusManager.shared.playSound("04_횡단보도가까이")
                crossWalkDetedtedCount = 0
            } else if StatusManager.shared.status != .haveToDepart, StatusManager.shared.status != .redSign, greenSignCount == 40 {
                // 초록불이지만 건너면 안 되는 경우
                StatusManager.shared.status = .arrived
                StatusManager.shared.playSound("07_초록불다음신호")
                greenSignCount = 0
            } else if StatusManager.shared.status != .haveToDepart, redSignCount % 40 == 1 {
                StatusManager.shared.status = .redSign
                StatusManager.shared.playSound("09_빨간불")
                redSignCount = 0
            }
//            else if StatusManager.shared.status == .haveToDepart, greenSignCount >= 20 {
//                // 지금 문제는, 빨간불 -> 초록불을 인식했음에도 다시 빨간불로 바뀌는 것.
//
//            }
            
            //Thread.sleep(forTimeInterval: 1.0)
            nowLabel = objectObservation.labels.first?.identifier
            
            if StatusManager.shared.status == .redSign, prevLabel == "red", nowLabel == "green" {
                print("신호가 바뀜")
                StatusManager.shared.updateStatus(to: .haveToDepart)
                StatusManager.shared.playSound("08_초록불건너자")
                // 신호가 바뀌었음을 알리는 소리 재생
            }
            // Transformations
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
            let transformedBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            
            let boxLayer = self.drawBoundingBox(transformedBounds)

            detectionLayer.addSublayer(boxLayer)
        }
    }
    
    func detectorCounting(_ observation: VNRecognizedObjectObservation) {
        // 빨간불, 파란불, 횡단보도 횟수 카운팅
        
        switch (observation.labels.first?.identifier ?? "") {
        case "Crosswalks", "crosswalk":
            crossWalkDetedtedCount += 1
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            impactFeedbackGenerator.prepare()
            impactFeedbackGenerator.impactOccurred()
        case "red":
            redSignCount += 1
            greenSignCount = 0
        case "green":
            greenSignCount += 1
            redSignCount = 0
        default:
            crossWalkDetedtedCount = 0
            redSignCount = 0
            greenSignCount = 0
        }
    
    }
    
    func setupLayers() {
        detectionLayer = CALayer()
        detectionLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        self.view.layer.addSublayer(detectionLayer)
    }
    
    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
    }
    
    func drawBoundingBox(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        boxLayer.cornerRadius = 4
        return boxLayer
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:]) // Create handler to perform request on the buffer

        do {
            try imageRequestHandler.perform(self.requests) // Schedules vision requests to be performed
        } catch {
            print(error)
        }
    }
}

