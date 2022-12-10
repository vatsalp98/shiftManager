class GqlFragments {
  static const CORE_USER_FIELDS = r'''
  fragment CoreUserFields on User {
        id
        given_name
        last_name
        email
        employeeId
        roles
        region {
          id 
          province
          city
        }
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
        maxSlots
        waitingQueue
        shiftType
        status
        region {
          id
          province
          city
        }
  }''';

  static const CORE_SHIFTUSER_FIELDS = r'''
  fragment CoreShiftUserFields on ShiftUser {
        id
        userId
        shiftId
        date
        status
  }''';

  static const CORE_AVAILABILITYUSER_FIELDS = r'''
  fragment CoreAvailabilityUserFields on AvailabilityUser {
    id
    date
    startTime
    endTime
    userId
  }''';
}
