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
