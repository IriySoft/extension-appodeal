#ifndef EXTENSION_APPODEAL_H
#define EXTENSION_APPODEAL_H

#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>

//typedef void (*AppodealCallback)(const char *event, const char *data);

@interface ListenerDelegate:NSObject <
    AppodealInitializationDelegate, 
    AppodealInterstitialDelegate,
    AppodealRewardedVideoDelegate>
@end

void logExt(NSString *message);
void sendEvent(int typeId, int messageId);

static BOOL inited = NO;
static BOOL initializing = NO;
static BOOL verboseLog = YES;

#endif
