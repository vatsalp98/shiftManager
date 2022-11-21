class GqlFragments {
  static const CORE_USER_FIELDS = r'''
  fragment CoreUserFields on User {
        id
        given_name
        last_name
        email
        employeeId
  }''';

  static const CORE_SHIFT_FIELDS = r'''
  fragment CoreShiftFields on Shift {
        id
        date
        startTime
        endTime
        isCancelled
        isRemote
        isNoShow
  }''';

  static const CORE_SHIFTUSER_FIELDS = r'''
  fragment CoreShiftUserFields on ShiftUser {
        id
        userId
        shiftId
  }''';

}