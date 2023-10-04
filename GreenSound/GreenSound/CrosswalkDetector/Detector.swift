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
            // 횡단보도 이탈 감지 : red 혹은 green이 잡혀도 이탈로 판단해야함
            if (StatusManager.shared.status == .haveToDepart || StatusManager.shared.status == .crossing || StatusManager.shared.status == .leave), emptyCount % 70 == 0 {
                StatusManager.shared.updateStatus(to: .leave)
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
            
            if StatusManager.shared.status == .finding, crossWalkDetedtedCount == 100 {
                print("횡단보도 10번 인식 후 재생")
                StatusManager.shared.updateStatus(to: .arrived)
                StatusManager.shared.playSound("05_횡단보도도착및신호등안내")
                crossWalkDetedtedCount = 0
            }
            else if StatusManager.shared.status == .arrived, greenSignCount >= 1 {
                // 초록불이지만 건너면 안 되는 경우
                StatusManager.shared.status = .readyToNext
                StatusManager.shared.playSound("07_초록불다음신호")
                greenSignCount = 0
            } else if (StatusManager.shared.status == .arrived || StatusManager.shared.status == .readyToNext), redSignCount % 40 == 1 {
                StatusManager.shared.updateStatus(to: .redSign)
                StatusManager.shared.playSound("09_빨간불")
                redSignCount = 0
            }
            else if  StatusManager.shared.status == .leave {
                let label = objectObservation.labels.first?.identifier ?? ""
                if label != "Crosswalks", label != "crosswalk" {
                    StatusManager.shared.playSound("10_횡단보도이탈")
                }
                else if crossWalkDetedtedCount >= 100 {
                    StatusManager.shared.updateStatus(to: .crossing)
                    StatusManager.shared.playSound("04_안전횡단중") // 안전횡단중입니다
                    crossWalkDetedtedCount = 0
                }
            }
            
            //Thread.sleep(forTimeInterval: 1.0)
            nowLabel = objectObservation.labels.first?.identifier
            
//            if StatusManager.shared.status == .redSign, prevLabel == "red", nowLabel == "green" { // 횡단보도와 함께 인식되는 경우, 빨간불 -> 초록불 바로 인식 안 됨
            if StatusManager.shared.status == .redSign, greenSignCount >= 1 {
                print("신호가 바뀜")
                StatusManager.shared.updateStatus(to: .haveToDepart)
                StatusManager.shared.playSound("08_초록불건너자")
                // 신호가 바뀌었음을 알리는 소리 재생
                greenSignCount = 0
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
            print("detect something")
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

