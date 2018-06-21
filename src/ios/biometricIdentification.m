/********* biometricIdentification.m Cordova Plugin Implementation *******/

#import "biometricIdentification.h"
#import "LocalAuthentication/LocalAuthentication.h"
@implementation biometricIdentification
//是否支持生物识别
-(bool)ifSupportBiometricIdentification
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        return true;
    }
    return false;
}
//是否支持faceid识别
-(bool)ifSupportFaceIdIdentification
{
    LAContext *context = [[LAContext alloc] init];
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]){
        if (@available(iOS 11.0, *)&&context.biometryType == LABiometryTypeFaceID) {
            return true;
        }
        return false;
        
    }
    return false;
}
//指纹验证方法
- (void) anthTouchID:(NSString *) describe complete:(void(^)(NSString *backStr)) complete extra:(CDVInvokedUrlCommand*)command
{
    //检查Touch ID是否可用
    LAContext *anthContext = [[LAContext alloc]init];
    NSError *error = [[NSError alloc]init];
    
    BOOL touchIDAvailable = [anthContext canEvaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    
    if (touchIDAvailable) {
        
        //指纹识别可用，获取验证结果
        [anthContext evaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:describe reply:^(BOOL success, NSError * _Nullable error) {
            
            //加入主线程中执行
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    //验证通过
                    if (complete) {
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"指纹正确"];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    }
                    
                } else {
                    
                    //验证失败
                    if (complete) {
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"请输入密码"];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    }
                }
            });
        }];
        
    } else {
        
        //指纹识别不可用
        if (complete) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"指纹识别不可用"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }
}
//face id 验证方法
-(void)anthFaceID:(void (^)(BOOL success, NSError *error))result extra:(CDVInvokedUrlCommand*)command{
    LAContext *context = [[LAContext alloc] init];
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"检测faceId" reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"faceId正确"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"请输入密码"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
    
}
//插件入口函数
- (void)BiometricIdentification:(CDVInvokedUrlCommand*)command
{
    //判断是否支持生物识别
    if([self ifSupportBiometricIdentification]==false){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"不支持生物识别"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    //支持指纹不支持faceId（非iPhoneX）
    if([self ifSupportFaceIdIdentification]==false){
        [self anthTouchID:@"测试指纹识别" complete:^(NSString *backStr) {
            NSLog(@"输出:%@",backStr);
        } extra:command];
        return;
    }
    //支持faceId(PhoneX)
    [self anthFaceID :^(BOOL success, NSError *error) {
        NSLog(@"输出:%@",error);} extra:command];
}

@end

