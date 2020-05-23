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
import Firebase
import FirebaseMLVision

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    lazy var vision = Vision.vision()
    private let userInitiatedQueue = DispatchQueue(label: "com.tuarua.vision.fce.uiq", qos: .userInitiated)
    private var results: [String: [VisionFace]] = [:]
    private var detector: VisionFaceDetector?
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let options = VisionFaceDetectorOptions(argv[0])
            else {
                return FreArgError().getError()
        }
        detector = self.vision.faceDetector(options: options)
        
        // TODO
        trace("FaceContourType.face.rawValue", FaceContourType.face.rawValue)
        trace("FaceContourType.leftEyebrowBottom.rawValue", FaceContourType.leftEyebrowBottom)

        return true.toFREObject()
    }
    
    func detect(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let image = VisionImage(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        userInitiatedQueue.async {
            self.detector?.process(image) { (features, error) in
                if let err = error as NSError? {
                    self.dispatchEvent(name: FaceEvent.DETECTED,
                                   value: FaceEvent(callbackId: callbackId, error: err).toJSONString())
                } else {
                    if let features = features, !features.isEmpty {
                        self.results[callbackId] = features
                        self.dispatchEvent(name: FaceEvent.DETECTED,
                                       value: FaceEvent(callbackId: callbackId).toJSONString())
                    }
                }
            }
        }
        return nil
    }
    
    func getResults(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let ret = results[id]?.toFREObject()
        results.removeValue(forKey: id)
        return ret
    }
    
    func close(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
}
