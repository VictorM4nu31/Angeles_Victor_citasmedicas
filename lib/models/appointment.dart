class Appointment {
  final int? id;
  final int userId;
  final String doctor;
  final String date;
  final String address;

  Appointment({this.id, required this.userId, required this.doctor, required this.date, required this.address});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'doctor': doctor,
      'date': date,
      'address': address,
    };
  }
}
