#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface SharePlugin : CDVPlugin {
}

- (void)share:(CDVInvokedUrlCommand*)command;

@end
