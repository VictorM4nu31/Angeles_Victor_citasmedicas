import 'package:flutter/material.dart';
import 'package:citas_medicas/screens/appointment_screen.dart';
import 'package:citas_medicas/screens/edit_appointment_screen.dart';
import 'package:citas_medicas/models/user.dart';
import 'package:citas_medicas/models/appointment.dart';
import 'package:citas_medicas/services/database_service.dart';
import '../widgets/appointment_card.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${user.firstName} ${user.lastName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: AppointmentList(user: user),
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentScreen(user: user)),
            );
          }
        },
      ),
    );
  }
}

class AppointmentList extends StatefulWidget {
  final User user;

  const AppointmentList({super.key, required this.user});

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment>>(
      future: _databaseService.getUserAppointments(widget.user.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var appointments = snapshot.data!;
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index];
              return AppointmentCard(
                appointment: appointment,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditAppointmentScreen(appointment: appointment)),
                  );
                },
                onDelete: () async {
                  await _databaseService.deleteAppointment(appointment.id!);
                  setState(() {});
                },
              );
            },
          );
        } else {
          return Center(child: Text('No hay citas'));
        }
      },
    );
  }
}
