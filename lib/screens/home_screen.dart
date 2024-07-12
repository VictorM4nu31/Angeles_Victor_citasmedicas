import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/appointment.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController doctorController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido "nombre" ("nombre_usuario")'),
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
                  final appointment = Appointment(
                    doctorName: doctorController.text,
                    date: dateController.text,
                    address: addressController.text,
                  );
                  await DatabaseHelper.instance.create(appointment);
                  Navigator.pushNamed(context, '/appointments');
                },
                child: const Text('Agendar'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Citas',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/appointments');
          }
        },
      ),
    );
  }
}
