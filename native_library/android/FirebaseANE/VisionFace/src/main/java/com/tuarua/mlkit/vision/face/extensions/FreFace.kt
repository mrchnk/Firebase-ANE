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
package com.tuarua.mlkit.vision.face.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.mlkit.vision.face.Face
import com.google.mlkit.vision.face.FaceContour
import com.google.mlkit.vision.face.FaceContour.*
import com.google.mlkit.vision.face.FaceLandmark
import com.google.mlkit.vision.face.FaceLandmark.*
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.set

fun Face.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.mlkit.vision.face.Face")
    ret["frame"] = boundingBox
    ret["hasTrackingId"] = true
    ret["trackingId"] = trackingId?.toFREObject()
    ret["hasHeadEulerAngleY"] = true
    ret["headEulerAngleY"] = headEulerAngleY
    ret["hasHeadEulerAngleZ"] = true
    ret["headEulerAngleZ"] = headEulerAngleZ
    ret["hasSmilingProbability"] = true
    ret["smilingProbability"] = smilingProbability?.toFREObject()
    ret["hasLeftEyeOpenProbability"] = true
    ret["leftEyeOpenProbability"] = leftEyeOpenProbability?.toFREObject()
    ret["hasRightEyeOpenProbability"] = true
    ret["rightEyeOpenProbability"] = rightEyeOpenProbability?.toFREObject()

    val landmarkTypes = listOf(
            FaceLandmark.LEFT_EYE, FaceLandmark.RIGHT_EYE,
            MOUTH_BOTTOM, MOUTH_RIGHT, MOUTH_LEFT,
            LEFT_EAR, RIGHT_EAR,
            FaceLandmark.LEFT_CHEEK, FaceLandmark.RIGHT_CHEEK,
            NOSE_BASE)

    val freLandMarks = FREArray("com.tuarua.mlkit.vision.face.FaceLandmark",
            items = landmarkTypes.mapNotNull { this.getLandmark(it)?.toFREObject() }) ?: return null
    ret["landmarks"] = freLandMarks

    val contourTypes = listOf(
            FACE,
            LEFT_EYEBROW_TOP, LEFT_EYEBROW_BOTTOM,
            RIGHT_EYEBROW_TOP, RIGHT_EYEBROW_BOTTOM,
            FaceContour.LEFT_EYE, FaceContour.RIGHT_EYE,
            UPPER_LIP_TOP, UPPER_LIP_BOTTOM,
            LOWER_LIP_TOP, LOWER_LIP_BOTTOM,
            NOSE_BRIDGE, NOSE_BOTTOM
    )
    val freContours = FREArray("com.tuarua.mlkit.vision.face.FaceContour",
            items = contourTypes.mapNotNull { this.getContour(it)?.toFREObject() }) ?: return null
    ret["contours"] = freContours
    return ret
}

fun List<Face>.toFREObject(): FREArray? {
    return FREArray("com.tuarua.mlkit.vision.face.Face",
            size, true, this.map { it.toFREObject() })
}
