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

package com.tuarua.mlkit.vision.barcode {
[RemoteClass(alias="com.tuarua.mlkit.vision.barcode.BarcodeCalendarEvent")]
/**
 * A calendar event extracted from a QR code.
 */
public class BarcodeCalendarEvent {
    /**
     * Calendar event end date.
     */
    public var end:Date;
    /**
     * Calendar event description.
     */
    public var eventDescription:String;
    /**
     * Calendar event location.
     */
    public var location:String;
    /**
     * Clendar event organizer.
     */
    public var organizer:String;
    /**
     * Calendar event start date.
     */
    public var start:Date;
    /**
     * Calendar event status.
     */
    public var status:String;
    /**
     * Calendar event summary.
     */
    public var summary:String;

    /** @private */
    public function BarcodeCalendarEvent() {
    }
}
}