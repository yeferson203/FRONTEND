import 'package:flutter/material.dart';
import 'usuarios.dart';
import 'inventario.dart';

void main() {
  runApp(MenuAdmin());
}

class MenuAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Definir la variable myhomepague y establecer un valor inicial
  bool myhomepague = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserTable()),
                );
              },
              child: Text('Ir a Usuarios'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Cambiar el valor de myhomepague al hacer clic en el botón
                setState(() {
                  myhomepague = !myhomepague;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyInventory()),
                );
              },
              child: Text('Ir a Inventario'),
            ),
          ],
        ),
      ),
    );
  }
}
