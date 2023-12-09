import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Formulario extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController identificationController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> submitForm(BuildContext context) async {
    Map<String, dynamic> newUser = {
      "contrasena": passwordController.text,
      "roll_id": 1,
      "identificacion_usuario": identificationController.text,
      "nombre_usuario": usernameController.text,
      "correo_electronico": emailController.text,
    };

    try {
      var response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/v1/usuarios/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newUser),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cuenta creada con éxito'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the text controllers
        passwordController.clear();
        identificationController.clear();
        usernameController.clear();
        emailController.clear();

        // Regresa a la pantalla anterior después de crear la cuenta
        Navigator.pop(context);
      } else {
        print(
            'Error al enviar la solicitud, código de estado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear usuario'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error al hacer la solicitud a la API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cuenta'),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BIENVENIDO \n '
                  'Crear Cuenta',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color.fromARGB(255, 124, 26, 26),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                ),
                TextField(
                  controller: identificationController,
                  decoration:
                      InputDecoration(labelText: 'Identificación Usuario'),
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Nombre Usuario'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Correo Electrónico'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => submitForm(context),
                  child: Text('Crear cuenta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
