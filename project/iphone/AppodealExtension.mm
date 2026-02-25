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
    NSString *_appId = [NSString stringWithUTF8String:appId];
    logExt([NSString stringWithFormat:@"Init with ID %@", _appId]);
    if (!inited && !initializing) {
      applicationId = _appId;
      initializing = YES;
      AppodealAdType adTypes = AppodealAdTypeInterstitial | AppodealAdTypeRewardedVideo;
      logExt([NSString stringWithFormat:@"Init - started for types %ld", adTypes]);

      [Appodeal setAutocache:YES types:adTypes]; 
      [Appodeal setLogLevel:APDLogLevelVerbose];

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

}

