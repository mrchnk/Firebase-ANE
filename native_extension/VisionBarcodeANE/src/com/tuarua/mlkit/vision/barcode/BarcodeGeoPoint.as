/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.mlkit.vision.barcode {
[RemoteClass(alias="com.tuarua.mlkit.vision.barcode.BarcodeGeoPoint")]
/**
 * GPS coordinates from a 'GEO:' or similar QR Code type data.
 */
public class BarcodeGeoPoint {
    private var _latitude:Number;
    private var _longitude:Number;
    /** @private */
    public function BarcodeGeoPoint(latitude:Number, longitude:Number) {
        this._latitude = latitude;
        this._longitude = longitude;

    }

    /**
     * A location latitude.
     */
    public function get latitude():Number {
        return _latitude;
    }
    /**
     * A location longitude.
     */
    public function get longitude():Number {
        return _longitude;
    }
}
}
