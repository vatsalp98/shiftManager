class GraphQLMutation {
  static const createAvailabilityUserMutation = r'''
  mutation MyMutation($date: AWSDateTime!, $endTime: AWSDateTime!, $startTime: AWSDateTime!, $userId: ID!) {
    createAvailabilityUser(input: {date: $date, endTime: $endTime, startTime: $startTime, userId: $userId}){
      id
    }
  }''';
}