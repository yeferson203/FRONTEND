import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/facturas.dart';

void main() {
  runApp(MyApp(
    carrito: [
      {'id': 1, 'nombre': 'Producto 1', 'cantidad': 2, 'precio_venta': 10.0},
      {'id': 2, 'nombre': 'Producto 2', 'cantidad': 1, 'precio_venta': 15.0},
    ],
  ));
}

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> carrito;

  MyApp({required this.carrito});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedido Detalles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(carrito: carrito),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Map<String, dynamic>> carrito;

  MyHomePage({required this.carrito});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> pedidosDetalles = [];
  bool mostrarDialogoExito = false;

  @override
  void initState() {
    super.initState();
    fetchData('http://127.0.0.1:8000/api/v1/pedidosdetalles/');
  }

  Future<void> fetchData(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        pedidosDetalles = List<Map<String, dynamic>>.from(responseData);
      });
    } else {
      print('Error al obtener los datos de $url: ${response.statusCode}');
    }
  }

  Future<void> addPedido(
      String cantidad, String precioUnitario, String productoId) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/pedidosdetalles/');
    final response = await http.post(
      url,
      body: {
        'cantidad': cantidad,
        'precio_unitario': precioUnitario,
        'producto': productoId,
      },
    );

    if (response.statusCode == 201) {
      await fetchData('http://127.0.0.1:8000/api/v1/pedidosdetalles/');
      mostrarDialogoExito = true;
    } else {
      print('Error al agregar el nuevo pedido: ${response.statusCode}');
    }
  }

  Future<void> _mostrarFormularioAgregarPedido(BuildContext context) async {
    for (var producto in widget.carrito) {
      TextEditingController cantidadController = TextEditingController();
      TextEditingController precioUnitarioController = TextEditingController();

      cantidadController.text = producto['cantidad'].toString();
      precioUnitarioController.text = producto['precio_venta'].toString();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Agregar Nuevo Pedido'),
                content: Column(
                  children: [
                    Text('Producto: ${producto['nombre']}'),
                    TextField(
                      controller: cantidadController,
                      decoration: InputDecoration(labelText: 'Cantidad'),
                    ),
                    TextField(
                      controller: precioUnitarioController,
                      decoration: InputDecoration(labelText: 'Precio Unitario'),
                      enabled: false,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String cantidad = cantidadController.text;
                      String precioUnitario = precioUnitarioController.text;
                      String productoId = producto['id'].toString();

                      await addPedido(cantidad, precioUnitario, productoId);

                      Navigator.of(context).pop();

                      if (mostrarDialogoExito) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Éxito'),
                              content: Text('Pedido realizado correctamente'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                        mostrarDialogoExito = false;
                      }
                    },
                    child: Text('Agregar Pedido'),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Pedido'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await _mostrarFormularioAgregarPedido(context);
              },
              child: Text('Agregar Nuevo Pedido'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Cantidad')),
                    DataColumn(label: Text('Precio Unitario')),
                    DataColumn(label: Text('Producto')),
                  ],
                  rows: pedidosDetalles
                      .map(
                        (pedidoDetalle) => DataRow(
                          cells: [
                            DataCell(Text('${pedidoDetalle['id']}')),
                            DataCell(Text('${pedidoDetalle['cantidad']}')),
                            DataCell(
                                Text('${pedidoDetalle['precio_unitario']}')),
                            DataCell(Text('${pedidoDetalle['producto']}')),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Cantidad')),
                    DataColumn(label: Text('Precio Unitario')),
                    DataColumn(label: Text('Producto')),
                  ],
                  rows: widget.carrito
                      .map(
                        (producto) => DataRow(
                          cells: [
                            DataCell(Text(producto['cantidad'].toString())),
                            DataCell(Text(producto['precio_venta'].toString())),
                            DataCell(Text(producto['nombre'].toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacturaTable(),
                  ),
                );
              },
              child: Text('Ver Factura'),
            ),
          ],
        ),
      ),
    );
  }
}
