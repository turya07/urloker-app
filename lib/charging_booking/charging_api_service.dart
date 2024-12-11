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

  Map<String, dynamic> toJson() {
    return {
      'guest': guest.toJson(),
      'location': location,
      'startDate': startDate,
      'startTime': startTime,
      'endDate': endDate,
      'endTime': endTime,
      'durationInMinutes': durationInMinutes,
      'dropOffTime': dropOffTime,
      'pickUpTime': pickUpTime,
      'notes': notes,
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

//================//

class BookingResponse {
  final bool success;
  final String message;
  final BookingData data;

  BookingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      success: json['success'],
      message: json['message'],
      data: BookingData.fromJson(json['data']),
    );
  }
}

class BookingData {
  final String bookingId;
  final String clientSecret;
  final int chargingFee;

  BookingData({
    required this.bookingId,
    required this.clientSecret,
    required this.chargingFee,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      bookingId: json['bookingId'],
      clientSecret: json['clientSecret'],
      chargingFee: json['chargingFee'],
    );
  }
}