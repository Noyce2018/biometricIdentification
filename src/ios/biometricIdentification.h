#import <Cordova/CDV.h>

@interface biometricIdentification : CDVPlugin {
    // Member variables go here.
    CDVPluginResult* pluginResult;
}
- (void)BiometricIdentification:(CDVInvokedUrlCommand*)command;
@end
