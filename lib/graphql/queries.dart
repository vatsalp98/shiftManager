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
}