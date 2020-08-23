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

public extension VisionTextElement {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.firebase.ml.vision.text.CloudTextElement")
            else { return nil }
        ret.frame = frame
        ret.text = text
        ret.cornerPoints = cornerPoints?.toFREObject()
        ret.confidence = confidence
        ret.recognizedLanguages = recognizedLanguages
        return ret.rawValue
    }
}

public extension Array where Element == VisionTextElement {
    func toFREObject() -> FREObject? {
        return FREArray(className: "com.tuarua.firebase.ml.vision.text.CloudTextElement",
                             length: self.count,
                             fixed: true,
                             items: self.compactMap { $0.toFREObject() }
        )?.rawValue
    }
}

public extension FreObjectSwift {
    subscript(dynamicMember name: String) -> [VisionTextElement]? {
        get { return nil }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
}
