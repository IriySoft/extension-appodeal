package org.haxe.extension;


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

  public static void Init(final String gameID) {
    Log.i(TAG, "Init called with id: " + gameID);
    Log.i(TAG, + "\ni:"+Appodeal.INTERSTITIAL +
      "\nr:"+Appodeal.REWARDED_VIDEO +
      "\nb:"+Appodeal.BANNER +
      "\nn:"+Appodeal.NATIVE +
      "\nm:"+Appodeal.MREC
    );
    Appodeal.initialize(
      Extension.mainActivity, 
      gameID, 
      (Appodeal.INTERSTITIAL | Appodeal.REWARDED_VIDEO), 
      new ApdInitializationCallback() {
        //@Override
        public void onInitializationFinished(@Nullable List<ApdInitializationError> errors) {
          Log.i(TAG, "Appodeal initialized "+errors);
          if (errors != null) {
            for (ApdInitializationError error : errors) Log.e(TAG, error.toString());
          }
        }    
      }
    );    
  }

  public static void ShowInterstitial() {
    Log.i(TAG, "Interstitial requested (loaded: "+Appodeal.isLoaded(Appodeal.INTERSTITIAL)+")");
    if (Appodeal.isLoaded(Appodeal.INTERSTITIAL)) {
      Appodeal.show(Extension.mainActivity, Appodeal.INTERSTITIAL);
    }
  }

  public static boolean IsLoaded(int adType) {
    Log.i(TAG, "IsLoaded "+adType+": "+Appodeal.isLoaded(adType));
    return Appodeal.isLoaded(adType);
  }


  public static int sampleMethod (int inputValue) {
    Log.i(TAG, "Init called");
    Appodeal.initialize(
      Extension.mainActivity, 
      "651866191e91d90e01a890d44e0131d9fc6c6a92741096d0", 
      (Appodeal.INTERSTITIAL | Appodeal.REWARDED_VIDEO), 
      new ApdInitializationCallback() {
        //@Override
        public void onInitializationFinished(@Nullable List<ApdInitializationError> errors) {
          Log.i(TAG, "Appodeal initialized "+errors);
          if (errors != null) {
            for (ApdInitializationError error : errors) Log.e(TAG, error.toString());
          }
        }    
      }
    );    
    return inputValue * 100;
    
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