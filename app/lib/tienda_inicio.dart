import 'package:flutter/material.dart';
import 'login.dart'; // Asegúrate de importar el archivo login.dart

void main() {
  runApp(TiendaInicio());
}

class TiendaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda de Motos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda de Motos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Utiliza un Stack para superponer el logo y el botón
            Stack(
              alignment: Alignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/mi_logo.png', // Asegúrate de tener la ruta correcta
                  width: 150,
                  height: 150,
                ),
                // Botón
                Positioned(
                  bottom: 0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navega a la pantalla de inicio de sesión al hacer clic
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                    child: Text('Iniciar Sesión'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
