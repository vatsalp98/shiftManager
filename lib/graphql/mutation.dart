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

  static const confirmShiftUserMutation = r'''
  mutation MyMutation($id: ID!, $shiftStatus: String) {
    updateShiftUser(input: {id: $id, shiftStatus: $shiftStatus}) {
      id
    }
  }''';

  static const updateShiftUserCheckInMutation = '''
  mutation MyMutation(\$id: ID!, \$isCheckedIn: Boolean, \$checkIn: AWSTime) {
    updateShiftUser(input: {id: \$id, isCheckedIn: \$isCheckedIn, checkIn: \$checkIn}) {
      id
    }
  }''';

  static const updateShiftUserCheckOutMutation = '''
  mutation MyMutation(\$id: ID!, \$isCheckedIn: Boolean, \$checkOut: AWSTime) {
    updateShiftUser(input: {id: \$id, isCheckedIn: \$isCheckedIn, checkOut: \$checkOut}) {
      id
    }
  }''';
}
