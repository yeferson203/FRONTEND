import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/formulario.dart';
import 'tienda_stock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda de Motos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> usuarios = [];
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool isAuthenticating = false;

  final Map<String, String> links = {
    "Usuarios": "http://127.0.0.1:8000/api/v1/usuarios/",
  };

  @override
  void initState() {
    super.initState();
    fetchData(links["Usuarios"]!);
  }

  Future<void> fetchData(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Datos recibidos: $data');

        setState(() {
          usuarios = List<Map<String, dynamic>>.from(data);
          print('Usuarios actualizados: $usuarios');
        });
      } else {
        print(
            'Error al hacer la solicitud, código de estado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error al hacer la solicitud a la API: $e');
    }
  }

  void authenticate() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    final bool isAuthenticated = usuarios.any((usuario) =>
        usuario['nombre_usuario'] == username &&
        usuario['contrasena'] == password);

    setState(() {
      isAuthenticating = true;
    });

    await Future.delayed(Duration(seconds: 2));

    if (isAuthenticated) {
      // Seteamos el nombre de usuario actual
      Login.setUsuarioActual(username);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Has iniciado sesión como $username'),
          backgroundColor: Colors.green,
        ),
      );

      // Navegar a la vista TiendaStock después de iniciar sesión correctamente
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TiendaStock()),
      );

      setState(() {
        errorMessage = '';
        isAuthenticating = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nombre de usuario o contraseña incorrectos'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        errorMessage = 'Nombre de usuario o contraseña incorrectos';
        isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda de Motos - Usuario: ${Login.getUsuarioActual()}'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isAuthenticating ? null : authenticate,
                child: Text('Iniciar Sesión'),
              ),
              if (isAuthenticating) LinearProgressIndicator(),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Formulario()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 160, 15, 15),
              ),
              child: Text(
                'Tienda de Motos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Login {
  static String usuarioActual =
      ''; // Variable estática para almacenar el nombre de usuario

  static String getUsuarioActual() {
    return usuarioActual;
  }

  static void setUsuarioActual(String username) {
    usuarioActual = username;
  }
}
