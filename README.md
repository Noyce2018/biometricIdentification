# biometricIdentification
一款针对iOS系统的Cordova插件，实现生物识别（即Touch ID以及Face ID）功能（iPhoneX调用此插件会调用Face ID，其它支持Touch ID的机型会调用Touch ID）
js调用实例：
            //成功回调
            var success=function(m){
                alert(m);
            };
            //失败回调
            var error=function(m){
                alert(m);
            };
            //test为测试用
            cordova.plugins.biometricIdentification.BiometricIdentification("test",success,error);
