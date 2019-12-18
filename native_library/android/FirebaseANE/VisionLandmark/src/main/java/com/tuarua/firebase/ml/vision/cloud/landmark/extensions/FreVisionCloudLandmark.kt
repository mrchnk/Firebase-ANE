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

package com.tuarua.firebase.ml.vision.cloud.landmark.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.cloud.landmark.FirebaseVisionCloudLandmark
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.toFREObject
import com.tuarua.firebase.ml.vision.common.extensions.toFREObject

fun FirebaseVisionCloudLandmark.toFREObject(): FREObject? {
        val ret = FREObject("com.tuarua.firebase.ml.vision.cloud.landmark.CloudLandmark")
        ret["confidence"] = confidence.toFREObject()
        ret["landmark"] = landmark.toFREObject()
        ret["entityId"] = entityId.toFREObject()
        ret["frame"] = boundingBox?.toFREObject()
        ret["locations"] = locations.toFREObject()
        return ret
}

fun List<FirebaseVisionCloudLandmark>.toFREObject(): FREArray? {
    return FREArray("com.tuarua.firebase.ml.vision.cloud.landmark.CloudLandmark",
            size, true, this.map { it.toFREObject() })
}