import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shift_manager/graphql/mutation.dart';
import 'package:shift_manager/graphql/queries.dart';
import 'package:intl/intl.dart';

class DataRepo {
  final awsDateFormat = DateFormat('yyyy-MM-dd');
  final awsTimeFormat = DateFormat('hh:mm:ss.sss');


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
    final operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: GraphQLMutation.createAvailabilityUserMutation,
        apiName: 'shiftmanager-cognito',
        variables: {
          "userId": userId,
          "startTime": awsTimeFormat.format(startTime),
          "endTime": awsTimeFormat.format(endTime),
          "date": awsDateFormat.format(date),
        },
      ),
    );
    final result = await fetchRequestItems(operation: operation, queryName: "createAvailabilityUser", isMany: false);
    return result;
  }

  listAvailabilityUser(String userId, String date) async {
    print(userId);
    print(date);
    final operation = Amplify.API.query(
      request: GraphQLRequest(
        document: GraphQLQueries.listAvailabilityByUser,
        variables: {
          "eq": userId,
          "eq1": date,
        },
        apiName: 'shiftmanager',
      ),
    );
    final result = await fetchRequestItems(
        operation: operation, queryName: "listAvailabilityUsers");
    print(result);
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
