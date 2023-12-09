import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario Flutter',
      home: MyInventory(),
    );
  }
}

class MyInventory extends StatefulWidget {
  @override
  _MyInventoryState createState() => _MyInventoryState();
}

class _MyInventoryState extends State<MyInventory> {
  final String apiUrl = "http://127.0.0.1:8000/api/v1/productos/";
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          products = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print(
            "Error al cargar los productos. Código de estado: ${response.statusCode}");
      }
    } catch (e) {
      print("Error de red: $e");
    }
  }

  Future<void> _editarProducto(int index) async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/v1/productos/${products[index]['id']}/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final productoAEditar = json.decode(response.body);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Editar Producto'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // ... (código restante)
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    final response = await http.put(
                      Uri.parse(apiUrl),
                      body: json.encode(productoAEditar),
                      headers: {'Content-Type': 'application/json'},
                    );

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      fetchProducts();
                      Navigator.of(context).pop();
                    } else {
                      print(
                          'Error al actualizar el producto: ${response.statusCode}');
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error al obtener el producto: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _eliminarProducto(int index) async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/v1/productos/${products[index]['id']}/';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 204) {
        setState(() {
          products.removeAt(index);
        });
        print('Producto eliminado con éxito');
      } else {
        print('Error al eliminar el producto: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario Flutter'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Precio Compra')),
                DataColumn(label: Text('Precio Venta')),
                DataColumn(label: Text('Imagen')),
                DataColumn(label: Text('Color')),
                DataColumn(label: Text('Stock Disponible')),
                DataColumn(label: Text('Categoría')),
                DataColumn(label: Text('Talla')),
                DataColumn(label: Text('Editar')),
                DataColumn(label: Text('Eliminar')),
              ],
              rows: products.map((product) {
                return DataRow(
                  cells: [
                    DataCell(Text(product['id'].toString() ?? '')),
                    DataCell(Text(product['nombre'] ?? '')),
                    DataCell(Text(product['descripcion'] ?? '')),
                    DataCell(Text(product['precio_compra']?.toString() ?? '')),
                    DataCell(Text(product['precio_venta']?.toString() ?? '')),
                    DataCell(
                      product['imagen'] != null
                          ? Image.network(
                              product['imagen'],
                              width: 50,
                              height: 50,
                            )
                          : Container(),
                    ),
                    DataCell(Text(product['color'] ?? '')),
                    DataCell(Text(
                        product['disponibilidad_stock']?.toString() ?? '')),
                    DataCell(Text(product['categoria']?.toString() ?? '')),
                    DataCell(Text(product['talla']?.toString() ?? '')),
                    DataCell(
                      IconButton(
                        onPressed: () {
                          _editarProducto(products.indexOf(product));
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                    DataCell(
                      IconButton(
                        onPressed: () {
                          _eliminarProducto(products.indexOf(product));
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchProducts();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
