class GraphQLMutation {
  static const createAvailabilityUserMutation = r'''
  mutation MyMutation($date: AWSDate!, $endTime: AWSTime!, $startTime: AWSTime!, $userId: ID!) {
    createAvailabilityUser(input: {date: $date, endTime: $endTime, startTime: $startTime, userId: $userId}){
      id
    }
  }''';

  static const deleteAvailabilityUser = r'''
  mutation MyMutation($id: ID!) {
    deleteAvailabilityUser(input: {id: $id}) {
      id
    }
  }''';
}