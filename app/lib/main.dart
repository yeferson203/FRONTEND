import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<Map<String, dynamic>> categories = [];

  final Map<String, String> links = {
    "Categorías": "http://127.0.0.1:8000/api/v1/categorias/",
    "Tallas": "http://127.0.0.1:8000/api/v1/tallas/",
    "Productos": "http://127.0.0.1:8000/api/v1/productos/",
    "Pedidos Detalles": "http://127.0.0.1:8000/api/v1/pedidosdetalles/",
    "Usuarios": "http://127.0.0.1:8000/api/v1/usuarios/",
    "Facturas": "http://127.0.0.1:8000/api/v1/facturas/",
    "Pedidos": "http://127.0.0.1:8000/api/v1/pedidos/"
  };

  Future<void> fetchData(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Datos recibidos: $data');

        setState(() {
          categories = List<Map<String, dynamic>>.from(data);
          print('Categorías actualizadas: $categories');
        });
      } else {
        print(
            'Error al hacer la solicitud, código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al hacer la solicitud a la API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda de Motos'),
      ),
      body: DataTable(
        columns: [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Descripción')),
        ],
        rows: categories
            .map(
              (category) => DataRow(
                cells: [
                  DataCell(Text(category['id']?.toString() ?? '')),
                  DataCell(Text(category['descripcion']?.toString() ?? '')),
                ],
              ),
            )
            .toList(),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
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
            for (var entry in links.entries)
              ListTile(
                title: Text(entry.key),
                onTap: () {
                  fetchData(entry.value);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
