var aws = require('aws-sdk');
var cognitoidentityserviceprovider = new aws.CognitoIdentityServiceProvider({apiVersion: '2016-04-18'});

exports.handler = async (event) => {
    var params = {
        UserPoolId: 'ca-central-1_HOd1rRzE2' /* required */
    };
    cognitoidentityserviceprovider.describeUserPool(params, function(err, data) {
        if (data) {
            console.log(data);
            return {
                statusCode: 200,
                body: data['EstimatedNumberOfUsers'],
            };
        }
        else if(err) {
            console.log(err);
        }
    });
};
