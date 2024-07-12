import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/appointment.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  AppointmentListScreenState createState() => AppointmentListScreenState();
}

class AppointmentListScreenState extends State<AppointmentListScreen> {
  late Future<List<Appointment>> appointments;

  @override
  void initState() {
    super.initState();
    appointments = DatabaseHelper.instance.readAllAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: appointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay citas programadas.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final appointment = snapshot.data![index];
                return ListTile(
                  title: Text('Médico: ${appointment.doctorName}'),
                  subtitle: Text('Fecha: ${appointment.date}\nDirección: ${appointment.address}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit', arguments: appointment);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await DatabaseHelper.instance.delete(appointment.id!);
                          setState(() {
                            appointments = DatabaseHelper.instance.readAllAppointments();
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
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
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          }
        },
      ),
    );
  }
}
