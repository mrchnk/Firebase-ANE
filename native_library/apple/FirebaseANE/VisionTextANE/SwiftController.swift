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

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    lazy var vision = Vision.vision()
    private var results: [String: [VisionText?]] = [:]
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    func detect(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let image = VisionImage(argv[0]),
            let eventId = String(argv[1])
            else {
                return FreArgError(message: "detect").getError(#file, #line, #column)
        }
        
        let detector = vision.textDetector()
        detector.detect(in: image) { (result, error) in
            if let err = error as NSError? {
                self.dispatchEvent(name: TextEvent.RECOGNIZED,
                                   value: TextEvent(eventId: eventId,
                                                    error: ["text": err.localizedDescription,
                                                            "id": err.code]).toJSONString())
            } else {
                if let result = result, !result.isEmpty {
                    self.results[eventId] = result
                    self.dispatchEvent(name: TextEvent.RECOGNIZED,
                                       value: TextEvent(eventId: eventId).toJSONString())
                }
            }
        }
        return nil
    }
    
    func getResults(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let eventId = String(argv[0])
            else {
                return FreArgError(message: "getResults").getError(#file, #line, #column)
        }
        do {
            if let result = results[eventId] {
                let freArray = try FREArray(className: "com.tuarua.firebase.vision.TextBlock",
                                            length: result.count, fixed: true)
                var cnt: UInt = 0
                for text in result {
                    if let block = text as? VisionTextBlock, let freBlock = block.toFREObject() {
                        try freArray.set(index: cnt, value: freBlock)
                        cnt += 1
                    }
                }
                return freArray.rawValue
            }
        } catch {}
        
        return nil
    }
    
}