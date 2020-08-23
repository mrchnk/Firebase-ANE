/*
 * Copyright 2019 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tuarua.mlkit.vision.common {

import flash.display.BitmapData;

public class InputImage {
    private var _bitmapdata:BitmapData;
    private var _path:String;

    /**
     * Initializes a VisionImage object with the given image.
     *
     * @param bitmapdata BitmapData to use in vision detection. The given image should be rotated, so its
     * orientation up. Set to null if using the path param.
     * @param path File path to image file
     * @return A VisionImage instance with the given image.
     */
    public function InputImage(bitmapdata:BitmapData = null, path:String = null) {
        if (bitmapdata == null && path == null) {
            throw new ArgumentError("Please pass either bitmapdata or a path to constructor");
        }
        this._bitmapdata = bitmapdata;
        this._path = path;
    }

    /** @private */
    public function get bitmapdata():BitmapData {
        return _bitmapdata;
    }

    /** @private */
    public function get path():String {
        return _path;
    }
}
}
