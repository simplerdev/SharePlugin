#import "SharePlugin.h"
#import "SharePluginViewController.h"

@implementation SharePlugin

- (void)share:(CDVInvokedUrlCommand*)command {
    
    BOOL pluginSuccess = NO;
    CDVPluginResult* pluginResult = nil;
    NSString* message = [command.arguments objectAtIndex:0];
    if (message != nil && [message length] > 0) {
        
        NSURL* filePath = [NSURL fileURLWithPath:message];
        SharePluginViewController* previewViewController = [[SharePluginViewController alloc] init];
        pluginSuccess = [previewViewController viewFile:message usingViewController:[super viewController]];
        
    } else {
    }
    
}

@end
