import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:citas_medicas/models/user.dart';
import 'package:citas_medicas/models/appointment.dart';
import 'package:citas_medicas/services/database_service.dart';

class AppointmentScreen extends StatefulWidget {
  final User user;

  const AppointmentScreen({required this.user});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveAppointment() async {
    var appointment = Appointment(
      userId: widget.user.id!,
      doctor: _doctorController.text,
      date: _dateController.text,
      address: _addressController.text,
    );
    await _databaseService.insertAppointment(appointment);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar cita médica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _doctorController,
                      decoration: const InputDecoration(labelText: 'Médico'),
                    ),
                    TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Seleccionar fecha',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      readOnly: true,
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Dirección'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveAppointment,
                      child: const Text('Agendar'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
