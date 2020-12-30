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

@file:Suppress("FunctionName")

package com.tuarua.firebase.remoteconfig.extensions

import com.adobe.fre.FREObject
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings
import com.tuarua.frekotlin.*

fun FirebaseRemoteConfigSettings(freObject: FREObject?): FirebaseRemoteConfigSettings? {
    val rv = freObject ?: return null
    return FirebaseRemoteConfigSettings.Builder()
            .setFetchTimeoutInSeconds(Long(rv["fetchTimeout"]) ?: 60L)
            .setMinimumFetchIntervalInSeconds(Long(rv["minimumFetchInterval"]) ?: 0L)
            .build()
}

fun FirebaseRemoteConfigSettings.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.remoteconfig.RemoteConfigSettings")
    ret["fetchTimeout"] = fetchTimeoutInSeconds
    ret["minimumFetchInterval"] = minimumFetchIntervalInSeconds
    return ret
}

operator fun FREObject?.set(name: String, value: FirebaseRemoteConfigSettings) {
    val rv = this ?: return
    rv[name] = value.toFREObject()
}