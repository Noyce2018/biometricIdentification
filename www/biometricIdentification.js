var exec = require('cordova/exec');

exports.BiometricIdentification = function (arg0, success, error) {
    exec(success, error, 'biometricIdentification', 'BiometricIdentification', [arg0]);
};
