#import <Cordova/CDV.h>
//父类是CDVPlugin
@interface biometricIdentification : CDVPlugin {
    CDVPluginResult* pluginResult;
}
- (void)BiometricIdentification:(CDVInvokedUrlCommand*)command;
@end
