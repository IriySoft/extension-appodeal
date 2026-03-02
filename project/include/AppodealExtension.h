#ifndef EXTENSION_APPODEAL_H
#define EXTENSION_APPODEAL_H

#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>

//typedef void (*AppodealCallback)(const char *event, const char *data);

@interface InitDelegate:NSObject <AppodealInitializationDelegate>
@end

void logExt(NSString *message);

static BOOL inited = NO;
static BOOL initializing = NO;
static BOOL verboseLog = YES;

#endif
