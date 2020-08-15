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
@file:Suppress("FunctionName")

package com.tuarua.firebase.ml.vision.cloudtext.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.text.FirebaseVisionText
import com.tuarua.firebase.ml.vision.common.extensions.FREArray
import com.tuarua.firebase.ml.vision.text.extensions.set
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.set

fun FirebaseVisionText.TextBlock.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.ml.vision.text.CloudTextBlock")
    ret["lines"] = lines
    ret["frame"] = boundingBox
    ret["text"] = text
    confidence?.let { ret["confidence"] = it }
    ret["cornerPoints"] = FREArray(cornerPoints)
    ret["recognizedLanguages"] = recognizedLanguages
    return ret
}

fun List<FirebaseVisionText.TextBlock>.toFREObject(): FREArray? {
    return FREArray("com.tuarua.firebase.ml.vision.text.CloudTextBlock",
            size, true, this.map { it.toFREObject() })
}

operator fun FREObject?.set(name: String, value: List<FirebaseVisionText.TextBlock>) {
    val rv = this ?: return
    rv[name] = value.toFREObject()
}