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
package com.tuarua.firebase.auth

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.firebase.auth.extensions.AuthCredential
import com.tuarua.firebase.auth.extensions.OAuthProvider
import com.tuarua.firebase.auth.extensions.toFREObject
import com.tuarua.frekotlin.*
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private lateinit var authController: AuthController
    private lateinit var userController: UserController

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        authController = AuthController(context)
        userController = UserController(context)
        return true.toFREObject()
    }

    fun getCurrentUser(ctx: FREContext, argv: FREArgv): FREObject? {
        return userController.currentUser?.toFREObject()
    }

    fun getIdToken(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val forceRefresh = Boolean(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null
        userController.getIdToken(forceRefresh, callbackId)
        return null
    }

    fun createUserWithEmailAndPassword(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException()
        val email = String(argv[0]) ?: return null
        val password = String(argv[1]) ?: return null
        val callbackId = String(argv[2])
        authController.createUserWithEmailAndPassword(email, password, callbackId)
        return null
    }

    fun signInAnonymously(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0])
        authController.signInAnonymously(callbackId)
        return null
    }

    fun signInWithCustomToken(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0])
        val token = String(argv[1]) ?: return null
        authController.signInWithCustomToken(callbackId, token)
        return null
    }

    fun signInWithCredential(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val credential = AuthCredential(argv[0]) ?: return null
        val callbackId = String(argv[1])
        authController.signIn(credential, callbackId)
        return null
    }

    fun signInWithProvider(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val provider = OAuthProvider(argv[0]) ?: return null
        val callbackId = String(argv[1])
        authController.signIn(provider, callbackId)
        return null
    }

    fun updateProfile(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException()
        val displayName = String(argv[0])
        val photoUrl = String(argv[1])
        val callbackId = String(argv[2])
        userController.updateProfile(displayName, photoUrl, callbackId)
        return null
    }

    fun signOut(ctx: FREContext, argv: FREArgv): FREObject? {
        authController.signOut()
        return null
    }

    fun reload(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0])
        userController.reload(callbackId)
        return null
    }

    fun sendEmailVerification(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0])
        userController.sendEmailVerification(callbackId)
        return null
    }

    fun updateEmail(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val email = String(argv[0]) ?: return null
        val callbackId = String(argv[1])
        userController.updateEmail(email, callbackId)
        return null
    }

    fun updatePassword(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val password = String(argv[0]) ?: return null
        val callbackId = String(argv[1])
        userController.updatePassword(password, callbackId)
        return null
    }

    fun sendPasswordResetEmail(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val email = String(argv[0]) ?: return null
        val callbackId = String(argv[1])
        authController.sendPasswordResetEmail(email, callbackId)
        return null
    }

    fun deleteUser(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val callbackId = String(argv[0])
        userController.deleteUser(callbackId)
        return null
    }

    fun reauthenticateWithCredential(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val credential = AuthCredential(argv[0]) ?: return null
        val callbackId = String(argv[1])
        userController.reauthenticate(credential, callbackId)
        return null
    }

    fun reauthenticateWithProvider(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val provider = OAuthProvider(argv[0]) ?: return null
        val callbackId = String(argv[1])
        userController.reauthenticate(provider, callbackId)
        return null
    }

    fun unlink(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val provider = String(argv[0]) ?: return null
        val callbackId = String(argv[1])
        userController.unlink(provider, callbackId)
        return null
    }

    fun link(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val credential = AuthCredential(argv[0]) ?: return null
        val callbackId = String(argv[1])
        userController.link(credential, callbackId)
        return null
    }

    fun verifyPhoneNumber(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val phoneNumber = String(argv[0]) ?: return null
        val callbackId = String(argv[1])
        authController.verifyPhoneNumber(phoneNumber, callbackId)
        return null
    }

    fun setLanguageCode(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val code = String(argv[0]) ?: return null
        authController.setLanguageCode(code)
        return null
    }

    fun getLanguageCode(ctx: FREContext, argv: FREArgv): FREObject? {
        return authController.languageCode?.toFREObject()
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