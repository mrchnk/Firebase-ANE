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
import UIKit
import FreSwift

class FreNativeButton: UIButton {
    private var _id: String = ""
    private let NATIVE_BUTTON_EVENT: String = "NativeButtonEvent"
    private var context: FreContextSwift!
    private var _x: CGFloat = 0
    public var x: CGFloat {
        set {
            _x = newValue
        }
        get {
            return _x
        }
    }
    
    private var _y: CGFloat = 0
    public var y: CGFloat {
        set {
            _y = newValue
        }
        get {
            return _y
        }
    }
    
    func update(prop: FREObject, value: FREObject) {
        guard let propName = String(prop)
            else {
                return
        }
        if propName == "x" {
            x = CGFloat(value) ?? 0.0
        } else if propName == "y" {
            y = CGFloat(value) ?? 0.0
        } else if propName == "alpha" {
            self.alpha = CGFloat(value) ?? 1.0
        } else if propName == "visible" {
            if let visible = Bool(value) {
                self.isHidden = !visible
            }
        }
        self.setNeedsDisplay()
    }
    
    init?(ctx: FreContextSwift, freObject: FREObject, id: String) {
        guard let bmd = freObject["bitmapData"],
            let _x = CGFloat(freObject["x"]),
            let _y = CGFloat(freObject["y"]),
            let _visible = Bool(freObject["visible"])
            else {
                return nil
        }
        
        self._id = id
        var width = CGFloat()
        var height = CGFloat()
        var img: UIImage?
        let _alpha = CGFloat(freObject["alpha"]) ?? 1.0
        
        let asBitmapData = FreBitmapDataSwift(freObject: bmd)
        if let cgimg = asBitmapData.asCGImage() {
            img = UIImage(cgImage: cgimg, scale: UIScreen.main.scale, orientation: .up)
            if let img = img {
                width = img.size.width
                height = img.size.width
            }
        }
        asBitmapData.releaseData()
        super.init(frame: CGRect.init(x: _x, y: _y, width: width, height: height))
        context = ctx
        self.setBackgroundImage(img, for: .normal)
        self.addTarget(self, action: #selector(onTouchUp), for: UIControl.Event.touchUpInside)
        x = _x
        y = _y
        alpha = _alpha
        isHidden = !_visible
    }
    
    @objc func onTouchUp() {
        let sf = "{\"id\": \"\(_id)\", \"event\": \"click\"}"
        context.dispatchStatusEventAsync(code: sf, level: NATIVE_BUTTON_EVENT)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
