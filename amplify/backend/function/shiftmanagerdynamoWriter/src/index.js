
var aws = require('aws-sdk');
var ddb = new aws.DynamoDB();
 
exports.handler = async (event, context) => {
     
    let date = new Date();
 
    if (event.request.userAttributes.sub) {
        // console.log(event.request.userAttributes);
        let params = {
            Item: {
                'id': {S: event.request.userAttributes.sub},
                '__typename': {S: 'User'},
                'given_name': {S: event.request.userAttributes.given_name},
                'last_name': {S: event.request.userAttributes.family_name},
                'email': {S: event.request.userAttributes.email},
                'employeeId': {S: event.request.userAttributes['custom:employeeId']},
                'createdAt': {S: date.toISOString()},
                'updatedAt': {S: date.toISOString()},
            },
            TableName: 'User-ct5cyfv2gzevbf4beksdngpywu-dev'
        };

        // Call DynamoDB
        try {
            await ddb.putItem(params).promise()
            console.log("Success");
        } catch (err) {
            console.log("Error", err);
        }
 
        console.log("Success: Everything executed correctly");
        context.done(null, event);
    } else {
        console.log("Error : Something went wrong");
    }
}