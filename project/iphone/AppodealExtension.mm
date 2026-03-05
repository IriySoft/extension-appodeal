#include "Utils.h"
#include "AppodealExtension.h"
#include "MessageConsts.h"
#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>
#import <dispatch/dispatch.h>

@implementation ListenerDelegate
  // =========================== Init =========================== 
  - (void)appodealSDKDidInitialize {
    logExt(@"Appodeal SDK inited!");
    // Appodeal SDK did complete initialization
    inited = YES;
    initializing = NO;
    sendEvent(EVENT_INIT, MSG_SUCCESS);
  }

  // ======================= Interstitial =======================

  /**
   Method called when precached or usual interstitial view loads
   @warning If you want show only expensive ads, ignore this callback call with precache equal to YES
   *
   @param precache If precache is YES it means that precached ad loaded
   */
  - (void)interstitialDidLoadAdIsPrecache:(BOOL)precache {
    logExt([NSString stringWithFormat:@"Interstitial loaded, precache: %i", precache]);
    sendEvent(EVENT_INTERSTITIAL, MSG_LOADED);
  }

  /**
   Method called if interstitial mediation failed
   */
  - (void)interstitialDidFailToLoadAd {
    sendEvent(EVENT_INTERSTITIAL, MSG_LOAD_FAILED);
  }

  /**
   Method called if loaded interstital ad expired by timeout
   */

  - (void)interstitialDidExpired {
    sendEvent(EVENT_INTERSTITIAL, MSG_EXPIRED);
  }

  /**
   Method called if interstitial mediation was successful, but ready ad network can't show ad or
   ad presentation was too frequent according to your placement settings
   */
  - (void)interstitialDidFailToPresent {
    sendEvent(EVENT_INTERSTITIAL, MSG_SHOW_FAILED);
  }

  /**
   Method called when interstitial displays on screen
   */
  - (void)interstitialWillPresent {
    sendEvent(EVENT_INTERSTITIAL, MSG_SHOWN);
  }

  /**
   Method called after interstitial leaves the screen
   */
  - (void)interstitialDidDismiss {
    sendEvent(EVENT_INTERSTITIAL, MSG_CLOSED);
  }

  /**
   Method called when user taps on interstitial
   */

  - (void)interstitialDidClick {
    sendEvent(EVENT_INTERSTITIAL, MSG_CLICKED);
  }
  
  
  // ========================= Rewarded =========================
  - (void)rewardedVideoDidLoadAdIsPrecache:(BOOL)precache {
    // rewarded video was loaded
    logExt([NSString stringWithFormat:@"Rewarded loaded, precache: %i", precache]);
    sendEvent(EVENT_REWARDED, MSG_LOADED);
  }
   
  - (void)rewardedVideoDidFailToLoadAd {
    // rewarded video ad failed to load
    sendEvent(EVENT_REWARDED, MSG_LOAD_FAILED);
  } 

  - (void)rewardedVideoDidFailToPresentWithError:(NSError *)error {
    // rewarded video ad was loaded but failed to present due to ad netwotk error,
    // placement settings or invalid creative.
    // Error object that indicates error reason
    logExt([NSString stringWithFormat:@"Rewarded ad faled to show: %@", error]);
    sendEvent(EVENT_REWARDED, MSG_SHOW_FAILED);
  }
 
  - (void)rewardedVideoDidPresent {
    // rewarded video was presented
    sendEvent(EVENT_REWARDED, MSG_SHOWN);
  }
 
  - (void)rewardedVideoWillDismissAndWasFullyWatched:(BOOL)wasFullyWatched {
    // rewarded video was closed. 
    // wasFullyWatched boolean flag indicated that user watch video fully
    logExt([NSString stringWithFormat:@"Rewarded ad closed, watched: %i", wasFullyWatched]);
    sendEvent(EVENT_REWARDED, MSG_CLOSED);
  }

  - (void)rewardedVideoDidFinish:(float)rewardAmount name:(NSString *)rewardName {
    // rewarded video finished with some reward
    logExt([NSString stringWithFormat:@"Rewarded ad finished, reward: %.f, name: %@", rewardAmount, rewardName]);
    sendEvent(EVENT_REWARDED, MSG_FINISHED);
  }

  - (void)rewardedVideoDidClick {
    // Method is called when rewarded video is clicked
    sendEvent(EVENT_REWARDED, MSG_CLICKED);
  }

  - (void)rewardedVideoDidExpired {
    // rewarded video did expire and could not be shown
    sendEvent(EVENT_REWARDED, MSG_EXPIRED);
  }

@end // ListenerDelegate

static NSString *applicationId = nil;

void logExt(NSString *message) {
  if (verboseLog) NSLog(@"AppodealExt: %@", message);
}

void sendEvent(int typeId, int messageId) {
  dispatch_async(dispatch_get_main_queue(), ^{
    sendExternalEvent(appodealEvent(typeId), appodealMessage(messageId));
  });
}

namespace appodeal {

  void InitAppodeal(const char *appId, int adTypesInt, bool testing) {
    logExt(@"Init!");
    NSString *_appId = [NSString stringWithUTF8String:appId];
    logExt([NSString stringWithFormat:@"Init with ID %@, testing: %i", _appId, testing]);
    if (!inited && !initializing) {
      applicationId = _appId;
      initializing = YES;
      AppodealAdType adTypes = (AppodealAdType) adTypesInt; //AppodealAdTypeInterstitial | AppodealAdTypeRewardedVideo;
      logExt([NSString stringWithFormat:@"Init - started for types %ld", adTypes]);

      [Appodeal setAutocache:YES types:adTypes]; 
      [Appodeal setTestingEnabled:(testing ? YES : NO)];
      logExt(@"Init - creating Init delegate...");

      ListenerDelegate *listener = [[ListenerDelegate alloc] init];
      // Optional delegate for initialization completion
      [Appodeal setInitializationDelegate:listener];


      /// Any other pre-initialization
      /// app specific logic
      logExt(@"Init - Appodeal initialize...");
      [Appodeal initializeWithApiKey:_appId types:adTypes];

      if (adTypes & AppodealAdTypeRewardedVideo != 0) [Appodeal setRewardedVideoDelegate:listener];
      if (adTypes & AppodealAdTypeInterstitial != 0) [Appodeal setInterstitialDelegate:listener];
    } else {
      logExt([NSString stringWithFormat:@"Init - won't init twice (inited: %i initializing: %i)", inited, initializing]);
    }
  }

  void SetVerboseLog(bool isVerbose) {
    if (isVerbose) {
      logExt(@"Set verbose log to TRUE");
      verboseLog = YES;
      [Appodeal setLogLevel:APDLogLevelVerbose];
    } else {
      logExt(@"Set verbose log to FALSE");
      verboseLog = NO;
      [Appodeal setLogLevel:APDLogLevelOff];
    }
  }

  UIViewController * rootCotroller() {
    //return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];

    // iOS 15+ code below
    /*
    UIWindow * keyWindow = nil;
    for (UIWindowScene * scene in [[UIApplication sharedApplication] connectedScenes]) {
      if ([scene activationState] == UISceneActivationStateForegroundActive) {
        keyWindow = [scene keyWindow];
        break;
      }
    }
    if (keyWindow != nil) return [keyWindow rootViewController];
    return nil;
    */
  }

  void ShowInterstitial() {
    bool loaded = IsLoaded(AppodealAdTypeInterstitial);
    logExt([NSString stringWithFormat:@"Request Interstitial (loaded: %i)", loaded]);
    if (loaded) {
      UIViewController * rootViewController = rootCotroller();
      if (rootViewController != nil) {
        [Appodeal showAd:AppodealShowStyleInterstitial rootViewController:rootViewController];
      } else {
        logExt(@"Request Interstitial failed. Couldn't obtain UIViewController.");
        sendEvent(EVENT_INTERSTITIAL, MSG_SHOW_FAILED);
      }
    } else {
      logExt(@"Request Interstitial failed. Not loaded.");
      sendEvent(EVENT_INTERSTITIAL, MSG_SHOW_FAILED);
    }
  }

  void ShowRewarded() {
    bool loaded = IsLoaded(AppodealAdTypeRewardedVideo);
    logExt([NSString stringWithFormat:@"Request Rewarded (loaded: %i)", loaded]);
    if (loaded) {
      UIViewController * rootViewController = rootCotroller();
      if (rootViewController != nil) {
        [Appodeal showAd:AppodealShowStyleRewardedVideo rootViewController:rootViewController];
      } else {
        logExt(@"Request Rewarded failed. Couldn't obtain UIViewController.");
        sendEvent(EVENT_REWARDED, MSG_SHOW_FAILED);
      }
    } else {
      logExt(@"Request Rewarded failed. Not loaded.");
      sendEvent(EVENT_REWARDED, MSG_SHOW_FAILED);
    }
  }

  bool IsLoaded(int adTypeInt) {
    bool loaded = false;
    AppodealAdType adType = (AppodealAdType) adTypeInt;
    switch (adType) {
      case AppodealAdTypeInterstitial:
        if ([Appodeal isReadyForShowWithStyle: AppodealShowStyleInterstitial]) loaded = true;
        break;

      case AppodealAdTypeRewardedVideo:
        if ([Appodeal isReadyForShowWithStyle: AppodealShowStyleRewardedVideo]) loaded = true;
        break;

      //TODO: add other ad types check
    }
    logExt([NSString stringWithFormat:@"Check loaded for %i: %i", adTypeInt, loaded]);
    return loaded;
  }

  int GetAdId(int adType) {
    int adId = 0;
    switch (adType) {
      case 0: adId = (int) AppodealAdTypeInterstitial;       break;
      case 1: adId = (int) AppodealAdTypeRewardedVideo;      break;
      case 2: adId = (int) AppodealAdTypeBanner;             break;
      case 3: adId = (int) AppodealAdTypeNativeAd;           break;
      case 4: adId = (int) AppodealAdTypeMREC;               break;
      case 5: adId = (int) AppodealAdTypeNonSkippableVideo;  break;
    }
    logExt([NSString stringWithFormat:@"Ad ID for type %i is: %i", adType, adId]);
    return adId;
  }

}
