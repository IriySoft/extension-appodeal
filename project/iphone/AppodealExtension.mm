#include "Utils.h"
#include "AppodealExtension.h"
#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>

@implementation MyAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    [Appodeal setAutocache:YES types:AppodealAdTypeInterstitial | AppodealAdTypeRewardedVideo]; 
    [Appodeal setLogLevel:APDLogLevelVerbose];

    // Optional delegate for initialization completion
    [Appodeal setInitializationDelegate:self];

    /// Any other pre-initialization
    /// app specific logic

    [Appodeal initializeWithApiKey:@"APP KEY" types:AppodealAdTypeInterstitial | AppodealAdTypeRewardedVideo];
    
    return YES;
}

- (void)appodealSDKDidInitialize {
    NSLog(@"Hello, Appodeallo!");
    // Appodeal SDK did complete initialization
}

namespace appodeal {
	int SampleMethod(int inputValue) {
		NSLog(@"Sample Appodeal!");
		return inputValue * 100;
	}
}
@end // MyAppDelegate

