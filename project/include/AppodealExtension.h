#ifndef EXTENSION_APPODEAL_H
#define EXTENSION_APPODEAL_H

#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>

@interface InitDelegate:NSObject <AppodealInitializationDelegate>
@end

void logExt(NSString *message);

static BOOL inited = NO;
static BOOL verboseLog = YES;

#endif
