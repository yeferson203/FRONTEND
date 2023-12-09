import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarUsuario extends StatefulWidget {
  final String nombreUsuario;

  const EditarUsuario({required this.nombreUsuario});

  @override
  _EditarUsuarioState createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();
  TextEditingController _correoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.nombreUsuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
              ),
              TextFormField(
                controller: _contrasenaController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              TextFormField(
                controller: _correoController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
              ),
              // Agrega más campos según sea necesario
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _actualizarInformacionUsuario();
                },
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _actualizarInformacionUsuario() {
    String nuevoNombreUsuario = _nombreController.text;
    String nuevaContrasena = _contrasenaController.text;
    String nuevoCorreo = _correoController.text;

    updateResource(nuevoNombreUsuario, nuevaContrasena, nuevoCorreo);

    Navigator.pop(context); // Cierra la vista después de la actualización
  }

  Future<void> updateResource(String nuevoNombreUsuario, String nuevaContrasena,
      String nuevoCorreo) async {
    final url = Uri.parse(
        'http://localhost:8000/api/v1/usuarios/1/'); // Ajusta el ID según tus necesidades
    final data = {
      "nombre_usuario": nuevoNombreUsuario,
      "contrasena": nuevaContrasena,
      "correo_electronico": nuevoCorreo,
      // Agrega más campos según sea necesario
    };
    final response = await http.put(
      url,
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);
    } else {
      print('Error al actualizar el recurso: ${response.statusCode}');
    }
  }
}
