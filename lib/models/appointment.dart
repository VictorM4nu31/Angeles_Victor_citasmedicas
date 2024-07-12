class Appointment {
  final int? id;
  final String doctorName;
  final String date;
  final String address;

  Appointment({
    this.id,
    required this.doctorName,
    required this.date,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorName': doctorName,
      'date': date,
      'address': address,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      doctorName: map['doctorName'],
      date: map['date'],
      address: map['address'],
    );
  }

  Appointment copy({
    int? id,
    String? doctorName,
    String? date,
    String? address,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      address: address ?? this.address,
    );
  }
}
