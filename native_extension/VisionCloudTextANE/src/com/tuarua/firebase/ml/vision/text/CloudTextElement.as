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
package com.tuarua.firebase.ml.vision.text {

import flash.geom.Point;
import flash.geom.Rectangle;

[RemoteClass(alias="com.tuarua.firebase.ml.vision.text.TextElement")]
/**
 * A text element recognized in an image. A text element is roughly equivalent to a space-separated
 * word in most Latin-script languages.
 */
public class CloudTextElement {
    /**
     * The rectangle that contains the text element relative to the image in the default coordinate
     * space.
     */
    public var frame:Rectangle;
    /**
     * String representation of the text element that was recognized.
     */
    public var text:String;
    /**
     * The four corner points of the text element in clockwise order starting with the top left point
     * relative to the image in the default coordinate space. The objects are <code>flash.geom.Point</code>s.
     */
    public var cornerPoints:Vector.<Point> = new <Point>[];
    /**
     * An array of text lines that make up the block.
     */
    public var lines:Vector.<CloudTextLine> = new <CloudTextLine>[];
    /**
     * The confidence of the recognized text element. The value is 0 for all text recognizers except
     * for cloud text recognizers with model type <code>VisionCloudTextModelType.dense</code>.
     */
    public var confidence:Number;
    /**
     * An array of recognized languages in the text element. On-device text recognizers only detect
     * Latin-based languages, while cloud text recognizers can detect multiple languages. If no
     * languages are recognized, the array is empty.
     */
    public var recognizedLanguages:Vector.<TextRecognizedLanguage> = new <TextRecognizedLanguage>[];

    /** @private */
    public function CloudTextElement() {
    }
}
}
