import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shift_manager/graphql/mutation.dart';
import 'package:shift_manager/graphql/queries.dart';

class DataRepo {
  final awsDateFormat = DateFormat('yyyy-MM-dd');
  final awsTimeFormat = DateFormat('hh:mm:ss.sss');
  final humanTimeFormat = DateFormat('hh:mm:ss a');

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
          result['empty'] = data[queryName]['items'].length == 0 ||
                  data[queryName]['items'] == null
              ? true
              : false;
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

  createAvailabilityUser(String userId, String type, DateTime date) async {
    final operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: GraphQLMutation.createAvailabilityUserMutation,
        apiName: 'shiftmanager',
        variables: {
          "userId": userId,
          "type": type,
          "date": awsDateFormat.format(date),
        },
      ),
    );
    final result = await fetchRequestItems(
        operation: operation,
        queryName: "createAvailabilityUser",
        isMany: false);
    return result;
  }

  listAvailabilityUser(String date) async {
    final user = await Amplify.Auth.getCurrentUser();
    final operation = Amplify.API.query(
      request: GraphQLRequest(
        document: GraphQLQueries.listAvailabilityByUser,
        variables: {
          "eq": user.userId,
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
        request: GraphQLRequest(
            document: GraphQLMutation.deleteAvailabilityUser,
            variables: {"id": id},
            apiName: "shiftmanager"));
    final result = await fetchRequestItems(
        operation: operation,
        queryName: "deleteAvailabilityUser",
        isMany: false);
    return result;
  }

  listShiftUsers(String date) async {
    final user = await Amplify.Auth.getCurrentUser();
    final operation = Amplify.API.query(
      request: GraphQLRequest(
        document: GraphQLQueries.listShiftUsersQuery,
        variables: {
          "eq": user.userId,
          "eq1": date,
        },
        apiName: "shiftmanager",
      ),
    );
    final result = await fetchRequestItems(
        operation: operation, queryName: "listShiftUsers");
    return result;
  }

  listPreviousShiftUsers() async {
    final user = await Amplify.Auth.getCurrentUser();
    final now = DateTime.now();
    final operation = Amplify.API.query(
      request: GraphQLRequest(
        document: GraphQLQueries.listPreviousShiftUsersQuery,
        variables: {
          "eq": user.userId,
          'lt': awsDateFormat.format(now),
        },
        apiName: "shiftmanager",
      ),
    );
    final result = await fetchRequestItems(
        operation: operation, queryName: "listShiftUsers");
    return result;
  }

  listUpcomingShiftUsers() async {
    final user = await Amplify.Auth.getCurrentUser();
    final now = DateTime.now();
    final operation = Amplify.API.query(
      request: GraphQLRequest(
        document: GraphQLQueries.listUpcomingShiftUsersQuery,
        variables: {
          "eq": user.userId,
          'gt': awsDateFormat.format(now),
        },
        apiName: "shiftmanager",
      ),
    );
    final result = await fetchRequestItems(
        operation: operation, queryName: "listShiftUsers");
    return result;
  }

  listShiftDayUsers(String userId, String date) async {
    final operation = Amplify.API.query(
      request: GraphQLRequest(
        document: GraphQLQueries.listShiftUsersDayQuery,
        variables: {
          "eq": userId,
          "eq1": date,
        },
        apiName: "shiftmanager",
      ),
    );
    final result = await fetchRequestItems(
        operation: operation, queryName: "listShiftUsers");
    return result;
  }

  listShiftDaily() async {
    final user = await Amplify.Auth.getCurrentUser();
    final now = DateTime.now();
    final operation = Amplify.API.query(
      request: GraphQLRequest(
        document: GraphQLQueries.listShiftUsersDayQuery,
        variables: {
          "eq": user.userId,
          "eq1": awsDateFormat.format(now),
        },
        apiName: "shiftmanager",
      ),
    );
    final result = await fetchRequestItems(
        operation: operation, queryName: "listShiftUsers");
    return result;
  }

  updateShiftUser(String id, String status) async {
    final operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: GraphQLMutation.confirmShiftUserMutation,
        variables: {
          "id": id,
          "shiftStatus": status,
        },
        apiName: "shiftmanager",
      ),
    );
    final result = await fetchRequestItems(
        operation: operation, queryName: "updateShiftUser", isMany: false);
    return result;
  }

  updateShiftUserCheckIn(String id, String checkInTime) async {
    final operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: GraphQLMutation.updateShiftUserCheckInMutation,
        variables: {
          "id": id,
          "isCheckedIn": true,
          "checkIn": checkInTime,
        },
        apiName: "shiftmanager",
      ),
    );
    final result = await fetchRequestItems(
        operation: operation, queryName: "updateShiftUser", isMany: false);
    return result;
  }

  updateShiftUserCheckOut(String id, String checkOutTime) async {
    final operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: GraphQLMutation.updateShiftUserCheckOutMutation,
        variables: {
          "id": id,
          "isCheckedIn": false,
          "checkOut": checkOutTime,
        },
        apiName: "shiftmanager",
      ),
    );
    final result = await fetchRequestItems(
        operation: operation, queryName: "updateShiftUser", isMany: false);
    return result;
  }
}
