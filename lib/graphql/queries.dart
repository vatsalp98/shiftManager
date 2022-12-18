import 'fragments.dart';

class GraphQLQueries {
  static const listUsersQuery = '''
  ${GqlFragments.CORE_SHIFT_FIELDS}
  query MyQuery(\$eq: ID) {
    listShiftUsers(filter: {userId: {eq: \$eq}}) {
      items {
        id
        shift {
          ...CoreShiftFields
        }
      }
    }
  }''';

  static const listAvailabilityByUser = '''
 ${GqlFragments.CORE_AVAILABILITYUSER_FIELDS}
 query MyQuery(\$eq: ID, \$eq1: String) {
  listAvailabilityUsers(filter: {userId: {eq: \$eq}, date: {eq: \$eq1}}) {
    items {
      ...CoreAvailabilityUserFields
    }
  }
}
 ''';

  static const listShiftUsersQuery = '''
 ${GqlFragments.CORE_SHIFT_FIELDS}
 ${GqlFragments.CORE_USER_FIELDS}
  query MyQuery(\$eq: ID) {
   listShiftUsers(filter: {userId: {eq: \$eq}}) {
     items {
       id
       shiftStatus
       date
       shift {
         ...CoreShiftFields
       }
       user {
         ...CoreUserFields
       }
     }
   }
 }''';

  static const listUpcomingShiftUsersQuery = '''
  ${GqlFragments.CORE_SHIFT_FIELDS}
 ${GqlFragments.CORE_USER_FIELDS}
  query MyQuery(\$eq: ID, \$gt: String) {
   listShiftUsers(filter: {userId: {eq: \$eq}, date: {gt: \$gt}}) {
     items {
       id
       shiftStatus
       date
       shift {
         ...CoreShiftFields
       }
       user {
         ...CoreUserFields
       }
     }
   }
 }
  ''';

  static const listPreviousShiftUsersQuery = '''
  ${GqlFragments.CORE_SHIFT_FIELDS}
 ${GqlFragments.CORE_USER_FIELDS}
  query MyQuery(\$eq: ID, \$lt: String) {
   listShiftUsers(filter: {userId: {eq: \$eq}, date: {lt: \$lt}}) {
     items {
       id
       shiftStatus
       date
       shift {
         ...CoreShiftFields
       }
       user {
         ...CoreUserFields
       }
     }
   }
 }
  ''';

  static const listShiftUsersDayQuery = '''
 ${GqlFragments.CORE_SHIFT_FIELDS}
 ${GqlFragments.CORE_USER_FIELDS}
  query MyQuery(\$eq: ID, \$eq1: String) {
   listShiftUsers(filter: {userId: {eq: \$eq}, date: {eq: \$eq1}}) {
     items {
       id
       shiftStatus
       date
       checkIn
       checkOut
       isCheckedIn
       shift {
         ...CoreShiftFields
       }
       user {
         ...CoreUserFields
       }
     }
   }
 }''';
}
