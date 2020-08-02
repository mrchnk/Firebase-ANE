package views.examples {
import com.tuarua.Firebase;
import com.tuarua.firebase.Crashlytics;
import com.tuarua.fre.ANEError;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class CrashlyticsExample extends Sprite implements IExample {
    private var crashlytics:Crashlytics;
    private var btnForceCrash:SimpleButton = new SimpleButton("Force Crash");
    private var btnLog:SimpleButton = new SimpleButton("Log Message");
    private var btnException:SimpleButton = new SimpleButton("Log Exception");
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var isInited:Boolean;

    public function CrashlyticsExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
    }

    private function initMenu():void {
        statusLabel = new TextField(stageWidth - 100, 1400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.LEFT, Align.TOP);
        statusLabel.wordWrap = true;
        statusLabel.touchable = false;
        statusLabel.x = 50;

        addChild(statusLabel);

        btnException.x = btnLog.x = btnForceCrash.x = (stageWidth - 200) * 0.5;
        btnForceCrash.y = StarlingRoot.GAP;

        btnForceCrash.addEventListener(TouchEvent.TOUCH, onForceCrashClick);
        addChild(btnForceCrash);

        btnLog.y = btnForceCrash.y + StarlingRoot.GAP;
        btnLog.addEventListener(TouchEvent.TOUCH, onLogClick);
        addChild(btnLog);

        btnException.y = btnLog.y + StarlingRoot.GAP;
        btnException.addEventListener(TouchEvent.TOUCH, onExceptionClick);
        addChild(btnException);

        statusLabel.y = btnException.y + (StarlingRoot.GAP * 1.25);
    }

    private function onExceptionClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnException);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var testError:Error = new Error("AS message", 99);
            crashlytics.recordException(testError);
        }
    }

    private function onForceCrashClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnForceCrash);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            crashlytics.crash();
        }
    }

    private function onLogClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLog);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            crashlytics.userId = "123456789";
            crashlytics.setCustomKey("isLoggedIn", true);
            crashlytics.log("I am a test message 2");
        }
    }

    public function initANE():void {
        if (isInited) return;
        try {
            Crashlytics.enabled = true;
            crashlytics = Firebase.crashlytics();
            statusLabel.text += "did Crash On Previous Execution: " + crashlytics.didCrashOnPreviousExecution() + "\n";

        } catch (e:ANEError) {
            statusLabel.text += e.message + "\n";
            statusLabel.text += e.getStackTrace() + "\n";
        }
        isInited = true;
    }
}
}
