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

package com.tuarua.firebase.ml.vision.cloudlabel

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.label.FirebaseVisionImageLabel
import com.google.firebase.ml.vision.label.FirebaseVisionImageLabeler
import com.google.gson.Gson
import com.tuarua.firebase.ml.vision.common.extensions.FirebaseVisionImage
import com.tuarua.firebase.ml.vision.cloudlabel.events.CloudLabelEvent
import com.tuarua.firebase.ml.vision.cloudlabel.extensions.FirebaseVisionCloudImageLabelerOptions
import com.tuarua.firebase.ml.vision.cloudlabel.extensions.toFREObject
import com.tuarua.frekotlin.*
import kotlin.coroutines.CoroutineContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER")
class KotlinController : FreKotlinMainController {
    private var results: MutableMap<String, MutableList<FirebaseVisionImageLabel>> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = Dispatchers.Default
    private lateinit var labeler: FirebaseVisionImageLabeler

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val options = FirebaseVisionCloudImageLabelerOptions(argv[0])
        labeler = if (options != null) {
            FirebaseVision.getInstance().getCloudImageLabeler(options)
        } else {
            FirebaseVision.getInstance().cloudImageLabeler
        }
        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun process(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val image = FirebaseVisionImage(argv[0], ctx) ?: return null
        val callbackId = String(argv[1]) ?: return null
        GlobalScope.launch(bgContext) {
            labeler.processImage(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val result = task.result ?: return@addOnCompleteListener
                    results[callbackId] = result
                    dispatchEvent(CloudLabelEvent.RECOGNIZED,
                            gson.toJson(CloudLabelEvent(callbackId, null)))
                } else {
                    val error = task.exception
                    dispatchEvent(CloudLabelEvent.RECOGNIZED,
                            gson.toJson(
                                    CloudLabelEvent(callbackId, mapOf(
                                            "text" to error?.message.toString(),
                                            "id" to 0))
                            )
                    )
                }
            }
        }

        return null
    }

    fun getResults(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        val result = results[callbackId] ?: return null
        val ret = result.toFREObject()
        results.remove(callbackId)
        return ret
    }

    fun close(ctx: FREContext, argv: FREArgv): FREObject? {
        labeler.close()
        return null
    }

    override val TAG: String?
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }

}