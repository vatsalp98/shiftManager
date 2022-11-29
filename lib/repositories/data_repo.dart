import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shift_manager/graphql/mutation.dart';
import 'package:shift_manager/graphql/queries.dart';

class DataRepo {
  fetchRequestItems(
      {required GraphQLOperation operation,
      required String queryName,
      bool isMany = true}) async {
    Map result = {
      "data": [],
      "errorsExists": false,
      "error": [],
      "empty": false,
    };
    try {
      final response = await operation.response;
      if (response.errors.isNotEmpty) {
        result['errorsExists'] = true;
        result['error'] = response.errors;
        result['empty'] = true;
        return result;
      } else {
        result['errorsExists'] = false;
        var data = json.decode(response.data);
        if (isMany) {
          result['empty'] = data[queryName]['items'].length == 0 || data[queryName]['items'] == null ? true : false;
          result['data'] = data[queryName]['items'];
        } else {
          result['empty'] = data[queryName] == null ? true : false;
          result['data'] = data[queryName];
        }
        return result;
      }
    } on ApiException {
      rethrow;
    }
  }

  listShiftByUser(String userId) async {
    try {
      GraphQLOperation operation = Amplify.API.query(
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
      if (result.errors.isNotEmpty) {
        for (var element in result.errors) {
          throw (element.message);
        }
      } else {
        var data = json.decode(result.data);
        return data;
      }
    } on ApiException {
      rethrow;
    }
  }

  listAvailabilityUser(String userId) async {
    final operation = Amplify.API.query(
      request: GraphQLRequest(
        document: GraphQLQueries.listAvailabilityByUser,
        variables: {
          "eq": userId,
        },
        apiName: 'shiftmanager',
      ),
    );
    final result = fetchRequestItems(
        operation: operation, queryName: "listAvailabilityUsers");
    return result;
  }

  deleteAvailabilityUser(String id) async {
    final operation = Amplify.API.mutate(
      request: GraphQLRequest(document: GraphQLMutation.deleteAvailabilityUser,
      variables: {"id": id}, apiName: "shiftmanager-cognito")
    );
    final result = fetchRequestItems(operation: operation, queryName: "deleteAvailabilityUser", isMany: false);
    return result;
  }
}
