class BookingRequest {
  final Guest guest;
  final String location;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final int durationInMinutes;
  final String dropOffTime;
  final String pickUpTime;
  final String notes;

  BookingRequest({
    required this.guest,
    required this.location,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.durationInMinutes,
    required this.dropOffTime,
    required this.pickUpTime,
    required this.notes,
  });
}

class Guest {
  final String name;
  final String email;
  final String phone;

  Guest({
    required this.name,
    required this.email,
    required this.phone,
  });
}
