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

import FreSwift
import Foundation
import FirebaseAuth

extension AuthCredential {
    static func fromFREObject(_ freObject: FREObject?, completion: @escaping (AuthCredential?, Error?) -> Void) -> Void {
        guard let rv = freObject, let provider = String(rv["provider"]) else {
            return completion(nil, FreArgError(message: "invalid credential object"))
        }

        let param0 = String(rv["param0"])
        let param1 = String(rv["param1"])
        if provider == GoogleAuthProviderID {
            guard let idToken = param0, let accessToken = param1 else {
                return completion(nil, FreArgError(message: "idToken (param0) or accessToken (param1) needed"))
            }
            completion(GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken), nil)
        } else if provider == TwitterAuthProviderID {
            guard let token = param0, let secret = param1 else {
                return completion(nil, FreArgError(message: "token (param0) or secret (param1) needed"))
            }
            completion(TwitterAuthProvider.credential(withToken: token, secret: secret), nil)
        } else if provider == GitHubAuthProviderID {
            guard let token = param0 else {
                return completion(nil, FreArgError(message: "token (param0) needed"))
            }
            completion(GitHubAuthProvider.credential(withToken: token), nil)
        } else if provider == FacebookAuthProviderID {
            guard let accessToken = param0 else {
                return completion(nil, FreArgError(message: "accessToken (param0) needed"))
            }
            completion(FacebookAuthProvider.credential(withAccessToken: accessToken), nil)
        } else if provider == EmailAuthProviderID {
            guard let email = param0, let password = param1 else {
                return completion(nil, FreArgError(message: "email (param0) or password (param1) needed"))
            }
            completion(EmailAuthProvider.credential(withEmail: email, password: password), nil)
        } else if provider == PhoneAuthProviderID {
            guard let verificationId = param0, let code = param1 else {
                return completion(nil, FreArgError(message: "verificationId (param0) or code (param1) needed"))
            }
            completion(PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationId,
                    verificationCode: code), nil)
        } else if provider == GameCenterAuthProviderID {
            return GameCenterAuthProvider.getCredential(completion: completion)
        } else {
            completion(nil, FreArgError(message: "unsupported provider \(provider)"))
        }
    }
}
