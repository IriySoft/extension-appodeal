package extension.appodeal;

#if android
import lime.system.JNI;
#end

#if ios
import haxe.MainLoop;
import lime.system.CFFI;
#end

enum abstract AdType (Int) from Int to Int {
  var APPODEAL_INTERSTITIAL  = 0;
  var APPODEAL_REWARDED      = 1;
  var APPODEAL_BANNER        = 2;
  var APPODEAL_NATIVE        = 3;
  var APPODEAL_MREC          = 4;
  var APPODEAL_NON_SKIPPABLE = 5;
}

class Appodeal {
  public static var inited (default, null): Bool = false;
  private static var functionsCreated: Bool = false;
  private static var initStarted: Bool = false;

  private static function Log(message: String): Void {
    if (verboseLog) trace("Appodeal Extension: "+message);
  }

  /**
   * Event triggered for status updates from Appodeal.
   */
  private static var _callback: Null<String->String->Void> = null;

  /**
   * Add events' listener
   */
  public static function SetCallback(callback: String->String->Void): Void {
    Log("New callback is set.");
    _callback = callback;
  }
  
  /**
   * Dispatch an event, if there is a listener
   */
  public static function dispatchEvent(event: String, message: String): Void  {
    Log("Event received: "+event+" -> "+message+". Callback is set: "+(_callback != null));
    if (event == AppodealEvent.EVENT_INIT) {
      initStarted = false;
      inited = (message == AppodealEvent.MSG_SUCCESS);
    }
    if(_callback != null) _callback(event, message);
  }

  public static function Init(gameID: String, adTypes: Array <AdType>, testing: Bool = false): Void {
    Log("Try Init "+gameID+" with "+adTypes+" (testing: "+testing+")");
    if (inited) {
      Log("Warning! Appodeal SDK is already inited, won't init twice");
      return;
    }
    if (initStarted) {
      Log("Warning! Appodeal SDK is being inited, please wait for the result");
      return;
    }

    createFunctions();

    if (!functionsCreated) {
      Log("Warning! Couldn't create functions, won't init");
      return;
    }
    initStarted = true;

    var types: Int = 0;
    for (t in adTypes) types = types | GetAdId(t);
    Log("Init types INT: "+types);

    setVerboseLogF(verboseLog);

    #if android
    initF(gameID, types, testing, new CallbackHandler());
    //inited = true;
    #elseif ios
    //sample_method = cpp.Lib.load("appodeal", "appodeal_sample_method", 1);
    //var result: Int = sample_method(2);
    //Log("Sample result: "+result);
    //initF(gameID, types, testing, cpp.Callable.fromStaticFunction(onAppodealStatus));
    //var callback = function (event: cpp.ConstCharStar, data: cpp.ConstCharStar) {
      // trace("Event! "+event+" "+data);
    //};
    initF(gameID, types, testing, (e: String, d: String) -> Appodeal.OnAppodealStatus(e, d));
    /*init_c = cpp.Lib.load("appodeal", "appodeal_init", 4);
    Log("Call init with id: " + gameID + "(" + (init_c!=null) + ")");
    init_c(gameID, types, testing, onAppodealStatus);*/
    //inited = true;
    #end

  }

  //private static var sample_method: Int->Int = null;
  //private static var init_c: String->Int->Bool->Dynamic->Void = null;

  private static function GetAdId(type: AdType): Int {
    Log("Get ad id for " + type);
    var adID: Int = 0;
    if (functionsCreated) {
      adID = getAdIdF(type);
      Log("Got " + type + " -> " + adID);
    } else {
      Log("GetAdId function wasn't created - didn't you forget to call Init?..");
    }
    return adID;
  }

  public static function IsLoaded(type: AdType): Bool {
    if (!inited) {
      Log("Check loaded for ad type "+type);
      return false;
    }
    var adId: Int = GetAdId(type);
    Log("Check loaded for ad type "+type+" (id: "+adId+")");
    return isLoadedF(adId);
  }

  public static function ShowInterstitial(): Void {
    Log("Request interstitial");
    if (inited) showInterstitialF();
  }

  public static function ShowRewarded(): Void {
    Log("Request rewarded");
    if (inited) showRewardedF();
  }

  public static function SetVerboseLog(enable: Bool): Void {
    verboseLog = enable;
    Log("Set Verbose log "+enable);
    if (functionsCreated) setVerboseLogF(verboseLog);
  }

  #if android
  private static function createFunctions(): Void {
    if (functionsCreated) {
      Log("createFunctions - JNI Functions are already created!");
      return;
    }
    Log("Creating JNI functions...");
    initF = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "Init", "(Ljava/lang/String;IZLorg/haxe/lime/HaxeObject;)V");
    setVerboseLogF = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "SetVerboseLog", "(Z)V");
    showRewardedF = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "ShowRewarded", "()V");
    showInterstitialF = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "ShowInterstitial", "()V");
    getAdIdF = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "GetAdId", "(I)I");
    isLoadedF = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "IsLoaded", "(I)Z");
    functionsCreated = true;
  }
  #elseif ios
  private static function createFunctions(): Void {
    if (functionsCreated) {
      Log("createFunctions - CPP Functions are already loaded!");
      return;
    }
    Log("Loading CPP functions...");
    initF = cpp.Lib.load("appodeal", "appodeal_init", 4);
    setVerboseLogF = cpp.Lib.load("appodeal", "appodeal_set_verbose", 1);    
    showRewardedF = cpp.Lib.load("appodeal", "appodeal_show_rewarded", 0);
    showInterstitialF = cpp.Lib.load("appodeal", "appodeal_show_interstitial", 0);
    getAdIdF = cpp.Lib.load("appodeal", "appodeal_get_adid", 1);    
    isLoadedF = cpp.Lib.load("appodeal", "appodeal_is_loaded", 1);
    functionsCreated = true;
  }
  #else
  private static function createFunctions(): Void {
    Log("No functions will be created for this target.");
  }
  #end

  private static var verboseLog: Bool = false;

  private static var showInterstitialF: Void->Void = null;
  private static var showRewardedF: Void->Void = null;
  private static var getAdIdF: Int->Int = null;
  private static var isLoadedF: Int->Bool = null;
  private static var setVerboseLogF: Bool->Void = null;
  private static var initF: String->Int->Bool->Dynamic->Void = null;

  #if ios
  public static function OnAppodealStatus(event: String, data: String): Void {
    Log("Callback event: "+event+", data: "+data);
    @:keep
    MainLoop.runInMainThread(() -> dispatchEvent(event, data));
  }
  #end
}

#if android
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
    //Log("Callback: ('"+event+"'), ('"+data+"')");
    Appodeal.dispatchEvent(event, data);
  }
}
#end