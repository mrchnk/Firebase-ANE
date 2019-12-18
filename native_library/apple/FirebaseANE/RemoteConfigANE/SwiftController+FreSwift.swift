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

import Foundation
import FreSwift

extension SwiftController: FreSwiftMainController {
    @objc public func getFunctions(prefix: String) -> [String] {
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)setDefaults"] = setDefaults
        functionsToSet["\(prefix)setConfigSettings"] = setConfigSettings
        functionsToSet["\(prefix)getByteArray"] = getByteArray
        functionsToSet["\(prefix)getBoolean"] = getBoolean
        functionsToSet["\(prefix)getDouble"] = getDouble
        functionsToSet["\(prefix)getLong"] = getLong
        functionsToSet["\(prefix)getString"] = getString
        functionsToSet["\(prefix)getKeysByPrefix"] = getKeysByPrefix
        functionsToSet["\(prefix)fetch"] = fetch
        functionsToSet["\(prefix)activateFetched"] = activateFetched
        functionsToSet["\(prefix)activate"] = activate
        functionsToSet["\(prefix)fetchAndActivate"] = fetchAndActivate
        functionsToSet["\(prefix)getInfo"] = getInfo
        
        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        
        return arr
    }
    
    @objc public func dispose() {
    }
    
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift.init(freContext: ctx)
    }
    
    @objc public func onLoad() {
    }
}
