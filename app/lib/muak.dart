import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pamotos',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pamotos'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Otros elementos de la página

            SizedBox(height: 16.0),

            // Ejemplo de botón con efecto 3D
            Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Cambia la posición de la sombra
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Acción del botón
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Color de fondo del botón
                  elevation: 0, // Elimina la sombra predeterminada
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Mi Botón 3D',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),

            // Otros elementos de la página
          ],
        ),
      ),
    );
  }
}
