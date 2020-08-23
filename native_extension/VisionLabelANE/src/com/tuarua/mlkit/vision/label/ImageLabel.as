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

package com.tuarua.mlkit.vision.label {
[RemoteClass(alias="com.tuarua.mlkit.vision.label.ImageLabel")]
/**
 * Represents a label for an image.
 */
public class ImageLabel {
    /**
     * Confidence for the label in range [0, 1].
     */
    public var confidence:Number;
    // TODO docs
    public var index:int;
    /**
     * <p>The human readable label string in American English. For example: "Balloon".</p>
     *
     * <p>Note: this is not fit for display purposes, as it is not localized. Use the <code>entityId</code> and query<br>
     * the Knowledge Graph to get a localized description of the label.</p>
     */
    public var text:String;
    public function ImageLabel() {
    }
}
}