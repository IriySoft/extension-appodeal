package org.haxe.extension;

import org.haxe.lime.HaxeObject;

import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;

import android.util.Log;

import com.appodeal.ads.Appodeal;
import com.appodeal.ads.initializing.ApdInitializationError;
import com.appodeal.ads.initializing.ApdInitializationCallback;
import com.appodeal.ads.InterstitialCallbacks;
import com.appodeal.ads.RewardedVideoCallbacks;
//import com.appodeal.ads.utils.Log;
import com.appodeal.ads.utils.Log.LogLevel;

import androidx.annotation.Nullable;
import java.util.List;
/* 
  You can use the Android Extension class in order to hook
  into the Android activity lifecycle. This is not required
  for standard Java code, this is designed for when you need
  deeper integration.
  
  You can access additional references from the Extension class,
  depending on your needs:
  
  - Extension.assetManager (android.content.res.AssetManager)
  - Extension.callbackHandler (android.os.Handler)
  - Extension.mainActivity (android.app.Activity)
  - Extension.mainContext (android.content.Context)
  - Extension.mainView (android.view.View)
  
  You can also make references to static or instance methods
  and properties on Java classes. These classes can be included 
  as single files using <java path="to/File.java" /> within your
  project, or use the full Android Library Project format (such
  as this example) in order to include your own AndroidManifest
  data, additional dependencies, etc.
  
  These are also optional, though this example shows a static
  function for performing a single task, like returning a value
  back to Haxe from Java.
*/
public class AppodealSdk extends Extension {
  
  private static final String TAG = "Appodeal SDK";
  private static HaxeObject haxeCallback = null;

  private static final String EVENT_FUNC = "onStatus";

  // Callback event categories to avoid typos
  private static final String EVENT_INIT          = "onInit";
  private static final String EVENT_INTERSTITIAL  = "onInterstitial";
  private static final String EVENT_REWARDED      = "onRewarded";

  // Callback messages to avoid typos
  private static final String MSG_FAILURE     = "Failure";
  private static final String MSG_SUCCESS     = "Success";
  private static final String MSG_LOADED      = "Loaded";
  private static final String MSG_LOAD_FAILED = "Load Failed";
  private static final String MSG_SHOWN       = "Shown";
  private static final String MSG_SHOW_FAILED = "Show Failed";
  private static final String MSG_FINISHED    = "Finished";
  private static final String MSG_CLICKED     = "Clicked";
  private static final String MSG_CLOSED      = "Closed";
  private static final String MSG_EXPIRED     = "Expired";

  public static void Init(final String gameID, final int adTypes, final boolean testing, HaxeObject callback) {
    haxeCallback = callback;
    if (verboseLog) Log.i(TAG, "Init called with id: " + gameID + " adTypes: " + adTypes +" testing: "+testing);
    if (verboseLog) Log.i(TAG, "Callback: " + (haxeCallback != null));
    // Appodeal.setLogLevel(LogLevel.verbose);
    if (testing) {
      Appodeal.setTesting(true);
      // Appodeal.setLogLevel(LogLevel.verbose);
    }

    //Log.i(TAG, "Check i: "+(adTypes & Appodeal.INTERSTITIAL)+" / "+Appodeal.INTERSTITIAL);

    if ((adTypes & Appodeal.INTERSTITIAL) == Appodeal.INTERSTITIAL) setInterstitialCallbacks();
    if ((adTypes & Appodeal.REWARDED_VIDEO) == Appodeal.REWARDED_VIDEO) setRewardedCallbacks();

    Appodeal.initialize(
      Extension.mainActivity, 
      gameID, 
      adTypes,
      //(Appodeal.INTERSTITIAL | Appodeal.REWARDED_VIDEO), 
      new ApdInitializationCallback() {
        //@Override
        public void onInitializationFinished(@Nullable List<ApdInitializationError> errors) {
          if (errors != null) {
            if (verboseLog) Log.i(TAG, "Appodeal initialized with errors");
            if (verboseLog) for (ApdInitializationError error : errors) Log.e(TAG, error.toString());
            dispatch(EVENT_INIT, MSG_FAILURE);
            //if (haxeCallback != null) haxeCallback.call(EVENT_FUNC, new Object[]{EVENT_INIT, "Failed"});
          } else {
            if (verboseLog) Log.i(TAG, "Appodeal initialized successfully.");
            dispatch(EVENT_INIT, MSG_SUCCESS);
            //if (haxeCallback != null) haxeCallback.call(EVENT_FUNC, new Object[]{EVENT_INIT, "Success"});
          }
        }    
      }
    );    
  }

  static void dispatch(String event, String message) {
    if (verboseLog) Log.i(TAG, "Event: " + event + " with message: " + message);
    if (haxeCallback != null) haxeCallback.call(EVENT_FUNC, new Object[]{event, message});
  }

  static void setRewardedCallbacks() {
    
    Appodeal.setRewardedVideoCallbacks(new RewardedVideoCallbacks() {
      @Override
      public void onRewardedVideoLoaded(boolean isPrecache) {
        // Called when rewarded video is loaded
        if (verboseLog) Log.i(TAG, "Rewarded loaded: " + isPrecache);
        dispatch(EVENT_REWARDED, MSG_LOADED);
      }
      @Override
      public void onRewardedVideoFailedToLoad() {
        // Called when rewarded video failed to load
        dispatch(EVENT_REWARDED, MSG_LOAD_FAILED);
      }
      @Override
      public void onRewardedVideoShown() {
        // Called when rewarded video is shown
        dispatch(EVENT_REWARDED, MSG_SHOWN);
      }
      @Override
      public void onRewardedVideoShowFailed() {
        // Called when rewarded video show failed
        dispatch(EVENT_REWARDED, MSG_SHOW_FAILED);
      }
      @Override
      public void onRewardedVideoClicked() {
        // Called when rewarded video is clicked
        dispatch(EVENT_REWARDED, MSG_CLICKED);
      }
      @Override
      public void onRewardedVideoFinished(double amount, String currency) {
        // Called when rewarded video is viewed until the end
        if (verboseLog) Log.i(TAG, "Rewarded finished, reward: " + amount + " of "+currency);
        dispatch(EVENT_REWARDED, MSG_FINISHED);
      }
      @Override
      public void onRewardedVideoClosed(boolean finished) {
        // Called when rewarded video is closed
        if (verboseLog) Log.i(TAG, "Rewarded closed, finished: " + finished);
        dispatch(EVENT_REWARDED, MSG_CLOSED);
      }
      @Override
      public void onRewardedVideoExpired() {
        // Called when rewarded video is expired
        dispatch(EVENT_REWARDED, MSG_EXPIRED);
      }
    });
  }

  static void setInterstitialCallbacks() {
    Appodeal.setInterstitialCallbacks(new InterstitialCallbacks() {
      @Override
      public void onInterstitialLoaded(boolean isPrecache) {
        // Called when interstitial is loaded
        if (verboseLog) Log.i(TAG, "Interstitial loaded: " + isPrecache);
        dispatch(EVENT_INTERSTITIAL, MSG_LOADED);
      }
      @Override
      public void onInterstitialFailedToLoad() {
        // Called when interstitial failed to load
        dispatch(EVENT_INTERSTITIAL, MSG_LOAD_FAILED);
      }
      @Override
      public void onInterstitialShown() {
        // Called when interstitial is shown
        dispatch(EVENT_INTERSTITIAL, MSG_SHOWN);
      }
      @Override
      public void onInterstitialShowFailed() {
        // Called when interstitial show failed
        dispatch(EVENT_INTERSTITIAL, MSG_FINISHED);
      }
      @Override
      public void onInterstitialClicked() {
        // Called when interstitial is clicked
        dispatch(EVENT_INTERSTITIAL, MSG_CLICKED);
      }
      @Override
      public void onInterstitialClosed() {
        // Called when interstitial is closed
        dispatch(EVENT_INTERSTITIAL, MSG_CLOSED);
      }
      @Override
      public void onInterstitialExpired() {
        // Called when interstitial is expired
        dispatch(EVENT_INTERSTITIAL, MSG_EXPIRED);
      }
    });
  }

  private static boolean verboseLog = false;

  public static void SetVerboseLog(final boolean enable) {
    Log.i(TAG, "Verbose log set to "+enable);
    verboseLog = enable;
    if (enable) Appodeal.setLogLevel(LogLevel.verbose);
    else Appodeal.setLogLevel(LogLevel.none);
  }

  public static int GetAdId(final int adType) {
    int adId = 0;
    switch (adType) {
      case 0: adId = Appodeal.INTERSTITIAL;   break;
      case 1: adId = Appodeal.REWARDED_VIDEO; break;
      case 2: adId = Appodeal.BANNER;         break;
      case 3: adId = Appodeal.NATIVE;         break;
      case 4: adId = Appodeal.MREC;           break;
    }
    if (verboseLog) Log.i(TAG, "Ad ID by type: "+adType+" -> "+adId);
    return adId;
  }

  /*
  public static int GetInterstitialId() {return Appodeal.INTERSTITIAL;}
  public static int GetRewardedId()     {return Appodeal.REWARDED_VIDEO;}
  public static int GetNannerId()       {return Appodeal.BANNER;}
  public static int GetNativeId()       {return Appodeal.NATIVE;}
  public static int GetMrecId()         {return Appodeal.MREC;}
  */

  public static void ShowInterstitial() {
    if (verboseLog) Log.i(TAG, "Interstitial requested (loaded: "+Appodeal.isLoaded(Appodeal.INTERSTITIAL)+")");
    if (Appodeal.isLoaded(Appodeal.INTERSTITIAL)) {
      Appodeal.show(Extension.mainActivity, Appodeal.INTERSTITIAL);
    }
  }

  public static void ShowRewarded() {
    if (verboseLog) Log.i(TAG, "Rewarded requested (loaded: "+Appodeal.isLoaded(Appodeal.REWARDED_VIDEO)+")");
    if (Appodeal.isLoaded(Appodeal.REWARDED_VIDEO)) {
      Appodeal.show(Extension.mainActivity, Appodeal.REWARDED_VIDEO);
    }
  }

  public static boolean IsLoaded(int adType) {
    int adId = GetAdId(adType);
    if (verboseLog) Log.i(TAG, "IsLoaded type "+adType+"(id "+adId+"): "+Appodeal.isLoaded(adId));
    return Appodeal.isLoaded(adId);
  }

  /**
   * Called when an activity you launched exits, giving you the requestCode 
   * you started it with, the resultCode it returned, and any additional data 
   * from it.
   */
  public boolean onActivityResult (int requestCode, int resultCode, Intent data) {
    
    return true;
    
  }

  /**
   * Called when the activity receives th results for permission requests.
   */
  public boolean onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {

    return true;

  }
  
  
  /**
   * Called when the activity is starting.
   */
  public void onCreate (Bundle savedInstanceState) {
    
    
    
  }
  
  
  /**
   * Perform any final cleanup before an activity is destroyed.
   */
  public void onDestroy () {
    
    
    
  }
  
  
  /**
   * Called as part of the activity lifecycle when an activity is going into
   * the background, but has not (yet) been killed.
   */
  public void onPause () {
    
    
    
  }
  
  
  /**
   * Called after {@link #onStop} when the current activity is being 
   * re-displayed to the user (the user has navigated back to it).
   */
  public void onRestart () {
    
    
    
  }
  
  
  /**
   * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
   * to start interacting with the user.
   */
  public void onResume () {
    
    
    
  }
  
  
  /**
   * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
   * the activity had been stopped, but is now again being displayed to the 
   * user.
   */
  public void onStart () {
    
    
    
  }
  
  
  /**
   * Called when the activity is no longer visible to the user, because 
   * another activity has been resumed and is covering this one. 
   */
  public void onStop () {
    
    
    
  }
  
  
}