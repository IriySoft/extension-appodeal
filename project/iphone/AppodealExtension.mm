#include "Utils.h"
#include "AppodealExtension.h"
#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>

@interface InitDelegate:NSObject <AppodealInitializationDelegate>
@end

@implementation InitDelegate
  - (void)appodealSDKDidInitialize {
    log(@"Appodeal SDK inited!");
    // Appodeal SDK did complete initialization
    inited = YES;
    //[self release]
  }
@end // InitDelegate

static BOOL inited = NO;
static BOOL initializing = NO;
static BOOL verboseLog = YES;
static NSString *applicationId = nul;

void log(NSString *message) {
  if (verboseLog) NSLog(@"AppodealExt: %@", message);
}

namespace appodeal {

  int SampleMethod(int inputValue) {
    NSLog(@"Sample Appodeal!");
    return inputValue * 100;
  }

  void Init(const char *appId) {
    NSString *_appId = [NSString stringWithUTF8String:appId];
    log(@"Init with ID #@", _appId);
    if (!inited && !initializing) {
      applicationId = _appId;
      initializing = YES;
      AppodealAdType adTypes = AppodealAdTypeInterstitial | AppodealAdTypeRewardedVideo;
      log(@"Init - started for types #@", adTypes);

      [Appodeal setAutocache:YES types:adTypes]; 
      [Appodeal setLogLevel:APDLogLevelVerbose];

      log(@"Init - creating Init delegate...");

      // Optional delegate for initialization completion
      [Appodeal setInitializationDelegate:[[InitDelegate alloc] init]];

      /// Any other pre-initialization
      /// app specific logic
      log(@"Init - Appodeal initialize...");
      [Appodeal initializeWithApiKey:_appId types:adTypes];
    } else {
      log(@"Init - won't init twice (inited: #i initializing: #i)", inited, initializing);
    }
  }

}

