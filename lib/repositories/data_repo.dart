import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shift_manager/graphql/mutation.dart';
import 'package:shift_manager/graphql/queries.dart';

class DataRepo {
  listShiftByUser(String userId) async {
    try {
      final operation = Amplify.API.query(
        request: GraphQLRequest(
            document: GraphQLQueries.listUsersQuery,
            apiName: 'shiftmanager',
            variables: {
              "eq": userId,
            }),
      );
      final response = await operation.response;
      if (response.errors.isNotEmpty) {
        for (var element in response.errors) {
          throw (element.message);
        }
      } else {
        var data = json.decode(response.data);
        return data;
      }
    } on ApiException {
      rethrow;
    }
  }

  createAvailabilityUser(String userId, DateTime startTime, DateTime endTime,
      DateTime date) async {
    try {
      final operation = Amplify.API.mutate(
        request: GraphQLRequest(
          document: GraphQLMutation.createAvailabilityUserMutation,
          apiName: 'shiftmanager',
          variables: {
            "userId": userId,
            "startTime": "${startTime.toIso8601String()}Z",
            "endTime": "${endTime.toIso8601String()}Z",
            "date": "${date.toIso8601String()}Z",
          },
        ),
      );
      final result = await operation.response;
      if(result.errors.isNotEmpty) {
        for(var element in result.errors) {
          throw(element.message);
        }
      }
      else {
        var data = json.decode(result.data);
        return data;
      }
    } on ApiException {
      rethrow;
    }
  }
}
