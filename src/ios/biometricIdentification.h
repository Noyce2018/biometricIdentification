#import <Cordova/CDV.h>
@interface biometricIdentification : CDVPlugin {
    CDVPluginResult* pluginResult;
}
- (void)BiometricIdentification:(CDVInvokedUrlCommand*)command;
@end
