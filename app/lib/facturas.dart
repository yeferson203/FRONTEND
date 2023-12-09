import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class Factura {
  final int id;
  final String numeroFactura;
  final String fechaFactura;
  final String total;
  final int cliente;

  Factura({
    required this.id,
    required this.numeroFactura,
    required this.fechaFactura,
    required this.total,
    required this.cliente,
  });

  factory Factura.fromJson(Map<String, dynamic> json) {
    return Factura(
      id: json['id'],
      numeroFactura: json['numero_factura'],
      fechaFactura: json['fecha_factura'],
      total: json['total'],
      cliente: json['cliente'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FacturaTable(),
    );
  }
}

class FacturaTable extends StatefulWidget {
  @override
  _FacturaTableState createState() => _FacturaTableState();
}

class _FacturaTableState extends State<FacturaTable> {
  late List<Factura> facturas;
  final TextEditingController numeroFacturaController = TextEditingController();
  final TextEditingController fechaFacturaController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController clienteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse("http://127.0.0.1:8000/api/v1/facturas/"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        facturas = data.map((item) => Factura.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createResource() async {
    final url = Uri.parse("http://127.0.0.1:8000/api/v1/facturas/");
    final data = {
      "numero_factura": numeroFacturaController.text,
      "fecha_factura": fechaFacturaController.text,
      "total": totalController.text,
      "cliente": int.parse(clienteController.text),
    };

    final response = await http.post(
      url,
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print(responseData);
      showToast("Factura agregada con éxito");
      fetchData(); // Vuelve a cargar los datos después de agregar la factura
    } else {
      print('Error al crear el recurso: ${response.statusCode}');
      showToast("Error al agregar la factura");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Factura Table'),
      ),
      body: facturas != null
          ? DataTable(
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Número Factura')),
                DataColumn(label: Text('Fecha Factura')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Cliente')),
              ],
              rows: facturas
                  .map(
                    (factura) => DataRow(
                      cells: [
                        DataCell(Text(factura.id.toString())),
                        DataCell(Text(factura.numeroFactura)),
                        DataCell(Text(factura.fechaFactura)),
                        DataCell(Text(factura.total)),
                        DataCell(Text(factura.cliente.toString())),
                      ],
                    ),
                  )
                  .toList(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        tooltip: 'Agregar Factura',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Factura'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: numeroFacturaController,
                  decoration: InputDecoration(labelText: 'Número Factura'),
                ),
                TextField(
                  controller: fechaFacturaController,
                  decoration: InputDecoration(labelText: 'Fecha Factura'),
                ),
                TextField(
                  controller: totalController,
                  decoration: InputDecoration(labelText: 'Total'),
                ),
                TextField(
                  controller: clienteController,
                  decoration: InputDecoration(labelText: 'Cliente'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Agregar'),
              onPressed: () {
                createResource();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
