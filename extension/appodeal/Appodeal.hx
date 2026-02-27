package extension.appodeal;

import lime.system.CFFI;
import lime.system.JNI;

enum abstract AdType (Int) from Int to Int {
  var APPODEAL_INTERSTITIAL = 0;
  var APPODEAL_REWARDED     = 1;
  var APPODEAL_BANNER       = 2;
  var APPODEAL_NATIVE       = 3;
  var APPODEAL_MREC         = 4;
}

class Appodeal {
  public static var inited (default, null): Bool = false;

  static function Log(message: String): Void {
    if (verboseLog)
      trace("Appodeal Extension: " + message);
  }

  /**
   * Event triggered for status updates from Appodeal.
   */
  private static var _callback: Null<String->String->Void> = null;

  /**
   * Add events' listener
   */
  public static function SetCallback(callback: String->String->Void): Void {
    _callback = callback;
  }
  
  /**
   * Dispatcjh and event, if there is a listener
   */
  public static function dispatchEvent(event: String, message: String): Void  {
    Log("Callback received: " + event + ": " + message);
    if(_callback != null) _callback(event, message);
  }

  public static function Init(gameID: String, adTypes: Array <AdType>, testing: Bool = false): Void {
    Log("Try Init "+gameID+" with "+adTypes+" (testing: "+testing+")");
    var types: Int = 0;
    for (t in adTypes) types = types | GetAdId(t);
    Log("Init types INT: "+types);
    if (inited) Log("Warning! Appodeal SDK is already inited");

    #if android
    if (init_jni == null)
      init_jni = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "Init", 
        "(Ljava/lang/String;IZLorg/haxe/lime/HaxeObject;)V");
    init_jni(gameID, types, testing, new CallbackHandler());

    #elseif ios
    sample_method = cpp.Lib.load("appodeal", "appodeal_sample_method", 1);
    init_c        = cpp.Lib.load("appodeal", "appodeal_init", 1);
    var result: Int = sample_method(2);
    Log("Sample result: "+result);
    Log("Call init with id: " + gameID + "(" + (init_c!=null) + ")");
    init_c(gameID);
    #end

    inited = true;
  }

  private static var sample_method: Int->Int = null;
  private static var init_c: String->Void = null;

  private static function GetAdId(type: AdType): Int {
    Log("Get ad id for "+type+" (JNI created "+(getAdId_jni == null)+")");
    #if android
    if (getAdId_jni == null) 
      getAdId_jni = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "GetAdId", "(I)I");
    return getAdId_jni(type);
    #else
    return 0;
    #end
  }

  public static function IsLoaded(type: AdType): Bool {
    Log("Check loaded for "+type+" (JNI created "+(isLoaded_jni == null)+")");
    #if android
    if (isLoaded_jni == null) 
      isLoaded_jni = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "IsLoaded", "(I)Z");
    return isLoaded_jni(type);
    #else
    return false;
    #end
  }

  public static function ShowInterstitial(): Void {
    Log("Request interstitial (JNI created "+(showInterstitial_jni == null)+")");
    #if android
    if (showInterstitial_jni == null)
      showInterstitial_jni = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "ShowInterstitial", "()V");
    showInterstitial_jni();
    #end
  }

  public static function ShowRewarded(): Void {
    Log("Request rewarded (JNI created "+(showRewarded_jni == null)+")");
    #if android
    if (showRewarded_jni == null)
      showRewarded_jni = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "ShowRewarded", "()V");
    showRewarded_jni();
    #end
  }

  public static function SetVerboseLog(enable: Bool): Void {
    verboseLog = enable;
    Log("Set Verbose log "+enable+" (JNI created "+(setVerboseLog_jni == null)+")");
    #if android
    if (setVerboseLog_jni == null)
      setVerboseLog_jni = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "SetVerboseLog", "(Z)V");
    setVerboseLog_jni(enable);
    #end
  }

  private static var verboseLog: Bool = false;

  // private static var sample_method = CFFI.load("extension_appodeal", "extension_appodeal_sample_method", 1);
  private static var init_jni: String->Int->Bool->Dynamic->Void = null;
  private static var showInterstitial_jni: Void->Void = null;
  private static var showRewarded_jni: Void->Void = null;
  private static var getAdId_jni: Int->Int = null;
  private static var isLoaded_jni: Int->Bool = null;
  private static var setVerboseLog_jni: Bool->Void = null;
}

/**
 * Internal callback handler for Appodeal events.
 */
@:noCompletion
private class CallbackHandler #if (lime >= "8.0.0") implements lime.system.JNI.JNISafety #end {
  public function new(): Void {}

  @:keep
  #if (lime >= "8.0.0")
  @:runOnMainThread
  #end
  public function onStatus(event: String, data: String): Void  {
    Appodeal.dispatchEvent(event, data);
  }
}
