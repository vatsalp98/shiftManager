import 'package:amplify_flutter/amplify_flutter.dart';

class AuthRepo {
  static fetchCustomUserAttributes() async {
    try {
      Map myMap = {};
      final result = await Amplify.Auth.fetchUserAttributes();
      for (var element in result) {
        if (element.userAttributeKey.toString() == "sub") {
          continue;
        }
        else {
          myMap[element.userAttributeKey.toString()] = element.value;
        }
      }
      return myMap;
    } on AuthException {
      rethrow;
    }
  }
}