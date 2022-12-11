import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../amplifyconfiguration.dart';

Future<void> configureAmplify() async {
  AmplifyAPI awsApi = AmplifyAPI();

  AmplifyAuthCognito amplifyAuthCognito = AmplifyAuthCognito();
  try {
    Amplify.addPlugins([
      amplifyAuthCognito,
      awsApi,
    ]);
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException catch (e) {
    throw (e.message);
  }
}
