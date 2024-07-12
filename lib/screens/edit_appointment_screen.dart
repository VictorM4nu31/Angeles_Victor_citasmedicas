import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/appointment.dart';

class EditAppointmentScreen extends StatelessWidget {
  const EditAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointment = ModalRoute.of(context)!.settings.arguments as Appointment;

    final TextEditingController doctorController = TextEditingController(text: appointment.doctorName);
    final TextEditingController dateController = TextEditingController(text: appointment.date);
    final TextEditingController addressController = TextEditingController(text: appointment.address);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar cita'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: doctorController,
                decoration: const InputDecoration(
                  labelText: 'Medico',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Seleccionar fecha',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final updatedAppointment = Appointment(
                    id: appointment.id,
                    doctorName: doctorController.text,
                    date: dateController.text,
                    address: addressController.text,
                  );
                  await DatabaseHelper.instance.update(updatedAppointment);
                  Navigator.pushNamed(context, '/appointments');
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
