/*
 * Copyright 2018 Tua Rua Ltd.
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

@file:Suppress("FunctionName")

package com.tuarua.mlkit.vision.label.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.mlkit.vision.label.ImageLabel
import com.tuarua.frekotlin.*

fun ImageLabel.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.mlkit.vision.label.ImageLabel")
    ret["confidence"] = confidence
    ret["text"] = text
    ret["index"] = index
    return ret
}

fun List<ImageLabel>.toFREObject(): FREArray? {
    return FREArray("com.tuarua.mlkit.vision.label.ImageLabel",
            size, true, this.map { it.toFREObject() })
}