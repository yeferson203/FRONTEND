import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Formulario',
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  // Los controladores para los campos de entrada
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _rollIdController = TextEditingController();
  final TextEditingController _identificacionUsuarioController =
      TextEditingController();
  final TextEditingController _nombreUsuarioController =
      TextEditingController();
  final TextEditingController _correoElectronicoController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario Flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _contrasenaController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la contraseña';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rollIdController,
                decoration: InputDecoration(labelText: 'Roll ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el Roll ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _identificacionUsuarioController,
                decoration:
                    InputDecoration(labelText: 'Identificación Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la identificación del usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreUsuarioController,
                decoration: InputDecoration(labelText: 'Nombre Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _correoElectronicoController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el correo electrónico';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Guardar los datos en la base de datos
                      // Puedes acceder a los valores utilizando los controladores:
                      // _contrasenaController.text, _rollIdController.text, etc.
                      // Aquí puedes implementar la lógica para guardar los datos.
                      // Por ejemplo, puedes enviar una solicitud HTTP para almacenarlos en el servidor.
                      // Después de guardar los datos, puedes navegar a otra pantalla o realizar alguna acción adicional.
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context) => OtraPantalla()),
                      // );
                    }
                  },
                  child: Text('Crear cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
