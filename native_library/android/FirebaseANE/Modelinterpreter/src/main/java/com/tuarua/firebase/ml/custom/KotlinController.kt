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

package com.tuarua.firebase.ml.custom

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.common.modeldownload.FirebaseModelManager
import com.google.firebase.ml.custom.FirebaseModelInterpreter
import com.google.firebase.ml.custom.FirebaseModelInterpreterOptions
import com.google.gson.Gson
import com.tuarua.firebase.ml.common.modeldownload.extensions.FirebaseModelDownloadConditions
import com.tuarua.firebase.ml.common.modeldownload.extensions.FirebaseRemoteModel
import com.tuarua.firebase.ml.custom.extensions.FirebaseModelInputOutputOptions
import com.tuarua.firebase.ml.custom.extensions.FirebaseModelInputs
import com.tuarua.firebase.ml.custom.events.ModelInterpreterEvent
import com.tuarua.firebase.ml.custom.extensions.FirebaseCustomRemoteModel
import com.tuarua.firebase.ml.custom.extensions.FirebaseModelInterpreterOptions
import com.tuarua.frekotlin.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*
import kotlin.coroutines.CoroutineContext
import kotlin.experimental.and

@Suppress("unused", "UNUSED_PARAMETER")
class KotlinController : FreKotlinMainController {
    private val gson = Gson()
    private val bgContext: CoroutineContext = Dispatchers.Default
    private var isStatsCollectionEnabled = true
    private var modelOptions: FirebaseModelInterpreterOptions? = null

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        modelOptions = FirebaseModelInterpreterOptions(argv[0]) ?: return FreArgException()
        isStatsCollectionEnabled = Boolean(argv[1]) ?: true
        return true.toFREObject()
    }

    fun run(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 4 } ?: return FreArgException()
        val modelInputs = FirebaseModelInputs(argv[0]) ?: return null
        val options = FirebaseModelInputOutputOptions(argv[1]) ?: return null
        val maxResults = Int(argv[2]) ?: return null
        val numPossibilities = Int(argv[3]) ?: return null
        val callbackId = String(argv[4]) ?: return null
        val modelOptions = this.modelOptions ?: return null

        GlobalScope.launch(bgContext) {
            val interpreter = FirebaseModelInterpreter.getInstance(modelOptions)
            interpreter?.isStatsCollectionEnabled = isStatsCollectionEnabled
            interpreter?.run(modelInputs, options)?.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val result = task.result ?: return@addOnCompleteListener
                    val labelProbArray = result.getOutput<Array<ByteArray>>(0)

                    val sortedLabels = PriorityQueue<AbstractMap.SimpleEntry<Int, Float>>(
                            maxResults
                    ) { o1, o2 ->
                        o1.value.compareTo(o2.value)
                    }
                    for (i in 0 until numPossibilities) {
                        sortedLabels.add(AbstractMap.SimpleEntry(i, (labelProbArray[0][i] and 0xff.toByte()) / 255.0f))
                        if (sortedLabels.size > maxResults) {
                            sortedLabels.poll()
                        }
                    }
                    val reversed = sortedLabels.reversed()
                    val data = mutableListOf<Map<String, Any?>>()
                    for (entry in reversed) {
                        data.add(mapOf("index" to entry.key, "confidence" to entry.value))
                    }
                    dispatchEvent(ModelInterpreterEvent.OUTPUT,
                            gson.toJson(ModelInterpreterEvent(callbackId, data = data))
                    )
                } else {
                    val error = task.exception
                    dispatchEvent(ModelInterpreterEvent.OUTPUT,
                            gson.toJson(
                                    ModelInterpreterEvent(callbackId, error = mapOf(
                                            "text" to error?.message.toString(),
                                            "id" to 0))
                            )
                    )
                }
                interpreter.close()
            }

        }
        return null
    }

    fun isModelDownloaded(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val model = FirebaseRemoteModel(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null

        FirebaseModelManager.getInstance().isModelDownloaded(model).addOnCompleteListener { task ->
            dispatchEvent(ModelInterpreterEvent.IS_DOWNLOADED,
                    gson.toJson(ModelInterpreterEvent(callbackId, result = task.result))
            )
        }
        return null
    }

    fun deleteDownloadedModel(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val model = FirebaseRemoteModel(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null

        FirebaseModelManager.getInstance().deleteDownloadedModel(model).addOnCompleteListener { task ->
            dispatchEvent(ModelInterpreterEvent.DELETE_DOWNLOADED,
                    gson.toJson(ModelInterpreterEvent(callbackId, result = task.isSuccessful))
            )
        }
        return null
    }


    fun download(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val model = FirebaseCustomRemoteModel(argv[0]) ?: return FreArgException()
        val conditions = FirebaseModelDownloadConditions(argv[1]) ?: return FreArgException()
        val callbackId = String(argv[2]) ?: return null

        FirebaseModelManager.getInstance().download(model, conditions).addOnSuccessListener {
            dispatchEvent(ModelInterpreterEvent.DOWNLOAD,
                    gson.toJson(ModelInterpreterEvent(callbackId))
            )
        }.addOnFailureListener { error ->
            dispatchEvent(ModelInterpreterEvent.DOWNLOAD,
                    gson.toJson(
                            ModelInterpreterEvent(callbackId, error = mapOf(
                                    "text" to error.message.toString(),
                                    "id" to 0))
                    )
            )
        }

        return null
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
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