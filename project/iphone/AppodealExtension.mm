#include "Utils.h"
#include "AppodealExtension.h"
#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>

  @implementation InitDelegate
    - (void)appodealSDKDidInitialize {
      logExt(@"Appodeal SDK inited!");
      // Appodeal SDK did complete initialization
      inited = YES;
      //[self release]
    }
  @end // InitDelegate

  static BOOL initializing = NO;
  static NSString *applicationId = nil;


  void logExt(NSString *message) {
    if (verboseLog) NSLog(@"AppodealExt: %@", message);
  }


namespace appodeal {
  int SampleMethod(int inputValue) {
    logExt(@"Sample Appodeal!");
    return inputValue * 100;
  }

  void Init(const char *appId) {
    logExt(@"Init!");
    NSString *_appId = [NSString stringWithUTF8String:appId];
    logExt([NSString stringWithFormat:@"Init with ID %@", _appId]);
    if (!inited && !initializing) {
      applicationId = _appId;
      initializing = YES;
      AppodealAdType adTypes = AppodealAdTypeInterstitial | AppodealAdTypeRewardedVideo;
      logExt([NSString stringWithFormat:@"Init - started for types %ld", adTypes]);

      [Appodeal setAutocache:YES types:adTypes]; 

      logExt(@"Init - creating Init delegate...");

      // Optional delegate for initialization completion
      [Appodeal setInitializationDelegate:[[InitDelegate alloc] init]];

      /// Any other pre-initialization
      /// app specific logic
      logExt(@"Init - Appodeal initialize...");
      [Appodeal initializeWithApiKey:_appId types:adTypes];
    } else {
      logExt([NSString stringWithFormat:@"Init - won't init twice (inited: %i initializing: %i)", inited, initializing]);
    }
  }

  void SetVerboseLog(bool isVerbose) {
    if (isVerbose) {
      logExt(@"SetVerboseLog to TRUE");
      verboseLog = YES;
      [Appodeal setLogLevel:APDLogLevelVerbose];
    } else {
      logExt(@"SetVerboseLog to FALSE");
      verboseLog = NO;
      [Appodeal setLogLevel:APDLogLevelOff];
    }
  }

  int GetAdId(int adType) {
    int adId = 0;
    switch (adType) {
      case 0: adId = AppodealAdTypeInterstitial;       break;
      case 1: adId = AppodealAdTypeRewardedVideo;      break;
      case 2: adId = AppodealAdTypeBanner;             break;
      case 3: adId = AppodealAdTypeNativeAd;           break;
      case 4: adId = AppodealAdTypeMREC;               break;
      case 5: adId = AppodealAdTypeNonSkippableVideo;  break;
    }
    logExt([NSString stringWithFormat:@"Ad ID for type %i is: %i)", adType, adId]);
    return adId;
  }

}