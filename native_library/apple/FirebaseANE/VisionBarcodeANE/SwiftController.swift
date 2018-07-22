/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import Foundation
import FreSwift
import FirebaseMLVision
import AVFoundation

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    internal var results: [String: [VisionBarcode?]] = [:]
    lazy var vision = Vision.vision()
    internal var options: VisionBarcodeDetectorOptions?
    
    internal lazy var captureSession = AVCaptureSession()
    internal lazy var sessionQueue = DispatchQueue(label: "com.tuarua.firebase.vision.SessionQueue")
    internal var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    internal var cameraView: UIView?
    internal var cameraEventId: String?
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let options = VisionBarcodeDetectorOptions(argv[0])
            else {
                return FreArgError(message: "initController").getError(#file, #line, #column)
        }
        self.options = options
        return true.toFREObject()
    }
    
    func detect(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let image = VisionImage(argv[0]),
            let eventId = String(argv[1]),
            let options = self.options
            else {
                return FreArgError(message: "detect").getError(#file, #line, #column)
        }
        let barcodeDetector = vision.barcodeDetector(options: options)
        barcodeDetector.detect(in: image) { (features, error) in
            if let err = error as NSError? {
                self.dispatchEvent(name: BarcodeEvent.DETECTED,
                               value: BarcodeEvent(eventId: eventId,
                                                   error: ["text": err.localizedDescription,
                                                           "id": err.code]).toJSONString())
            } else {
                if let features = features, !features.isEmpty {
                    self.results[eventId] = features
                    self.dispatchEvent(name: BarcodeEvent.DETECTED,
                                   value: BarcodeEvent(eventId: eventId).toJSONString())
                }
            }
        }
        return nil
    }
    
    func getResults(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let eventId = String(argv[0])
            else {
                return FreArgError(message: "getResult").getError(#file, #line, #column)
        }
        do {
            if let result = results[eventId] {
                let freArray = try FREArray.init(className: "com.tuarua.firebase.vision.Barcode",
                                                 length: result.count, fixed: true)
                var cnt: UInt = 0
                for barcode in result {
                    if let freBarcode = barcode?.toFREObject() {
                        try freArray.set(index: cnt, value: freBarcode)
                        cnt += 1
                    } 
                }
                return freArray.rawValue
            }
        } catch {}
        
        return nil
    }
    
    // MARK: - Camera Input
    
    func inputFromCamera(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let eventId = String(argv[0]),
            let rvc = UIApplication.shared.keyWindow?.rootViewController
            else {
                return FreArgError(message: "inputFromCamera").getError(#file, #line, #column)
        }
        cameraEventId = eventId
        var mask: CGImage? = nil
        if let freMask = argv[1] {
            let asBitmapData = FreBitmapDataSwift.init(freObject: freMask)
            defer {
                asBitmapData.releaseData()
            }
            do {
                if let cgimg = try asBitmapData.asCGImage() {
                    mask = cgimg
                }
            } catch {
            }
        }
        inputFromCamera(rootViewController: rvc, eventId: eventId, mask: mask)
        return nil
    }
    
    func closeCamera(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let rvc = UIApplication.shared.keyWindow?.rootViewController
            else {
                return FreArgError(message: "closeCamera").getError(#file, #line, #column)
        }
        closeCamera(rootViewController: rvc)
        return nil
    }
    
}
