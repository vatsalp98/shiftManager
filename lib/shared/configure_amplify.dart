import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../amplifyconfiguration.dart';

Future<void> configureAmplify() async {
  // ignore: omit_local_variable_types
  AmplifyAuthCognito amplifyAuthCognito = AmplifyAuthCognito();
  try {
    Amplify.addPlugins([
      amplifyAuthCognito
    ]);
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException catch (e) {
    throw (e.message);
  }
}