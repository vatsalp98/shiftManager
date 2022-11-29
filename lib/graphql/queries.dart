import 'fragments.dart';

class GraphQLQueries {
 static  const listUsersQuery = '''
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
 query Mquery(\$eq: ID) {
   listAvailabilityUsers(filter: {userId: {eq: \$eq}}) {
     items {
       ...CoreAvailabilityUserFields
     }
   }
 }
 ''';
}