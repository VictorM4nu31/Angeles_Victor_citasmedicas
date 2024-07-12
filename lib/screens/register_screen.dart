import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ingresa tu nombre',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Ingresa apellido paterno',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Ingresa tu usuario',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Ingresa tu contraseña',
                prefixIcon: Icon(Icons.lock),
                obscureText: true,
              ),
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
                prefixIcon: Icon(Icons.lock),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text == confirmPasswordController.text) {
                  final user = User(
                    name: nameController.text,
                    lastName: lastNameController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                  );
                  await DatabaseHelper.instance.createUser(user);
                  Navigator.pushReplacementNamed(context, '/login'); // Asegúrate de que '/login' esté en tus rutas
                } else {
                  // Maneja el error de contraseñas que no coinciden
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
