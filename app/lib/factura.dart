import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  final String apiUrl = "http://127.0.0.1:8000/api/v1/facturas/";

  List<Map<String, dynamic>> facturas = [];

  TextEditingController _fechaController = TextEditingController();
  TextEditingController _clienteController = TextEditingController();
  late DateTime _fechaSeleccionada;

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Convierte la respuesta JSON a una lista de mapas
        List<dynamic> data = jsonDecode(response.body);

        // Actualiza la lista de facturas
        setState(() {
          facturas = List<Map<String, dynamic>>.from(data);
        });
      } else {
        // Maneja errores, por ejemplo, mostrando un mensaje de error en el log
        print("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      // Maneja excepciones, por ejemplo, mostrando un mensaje de error en el log
      print("Excepción durante la solicitud: $e");
    }
  }

  _showAddDialog() async {
    // Establece la fecha actual como fecha seleccionada
    _fechaSeleccionada = DateTime.now();

    // Configura el controlador con la fecha actual
    _fechaController.text = DateFormat('yyyy-MM-dd').format(_fechaSeleccionada);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Factura"),
          content: _buildAddForm(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                // Lógica para guardar la nueva factura
                _saveNewFactura();
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: "Número de Factura"),
        ),
        TextField(
          controller: _fechaController,
          decoration: InputDecoration(labelText: "Fecha de Factura"),
        ),
        TextField(
          decoration: InputDecoration(labelText: "Total"),
        ),
        TextField(
          controller: _clienteController,
          decoration: InputDecoration(labelText: "Cliente"),
        ),
        // Agrega más campos según sea necesario
      ],
    );
  }

  _saveNewFactura() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'numero_factura': 'valor_del_TextField_correspondiente',
          'fecha_factura': _fechaController.text,
          'total': 'valor_del_TextField_correspondiente',
          'cliente': _clienteController.text,
          // Otros campos según sea necesario
        }),
      );

      if (response.statusCode == 201) {
        // Si el servidor responde con un código 201 (creado), la factura se ha agregado correctamente
        print("Factura agregada con éxito");
        // Puedes volver a cargar la lista de facturas para reflejar la actualización
        _fetchData();
      } else {
        // Maneja errores, por ejemplo, mostrando un mensaje de error en el log
        print("Error al agregar la factura: ${response.statusCode}");
      }
    } catch (e) {
      // Maneja excepciones, por ejemplo, mostrando un mensaje de error en el log
      print("Excepción al agregar la factura: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facturas'),
      ),
      body: ListView.builder(
        itemCount: facturas.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Factura ${facturas[index]['numero_factura']}"),
              subtitle: Text("Fecha: ${facturas[index]['fecha_factura']}"),
              trailing: Text("Total: \$${facturas[index]['total']}"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Agregar Factura',
        child: Icon(Icons.add),
      ),
    );
  }
}
