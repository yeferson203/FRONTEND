import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pedidos.dart';

class PedidoDetalle extends StatefulWidget {
  final List<Map<String, dynamic>> carrito;

  PedidoDetalle({required this.carrito});

  @override
  _PedidoDetalleState createState() => _PedidoDetalleState();
}

class _PedidoDetalleState extends State<PedidoDetalle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Pedido'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Mostrar el carrito (puedes implementar esto si lo necesitas)
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Navegar a la vista de pedidos.dart
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(carrito: widget.carrito)),
              );
            },
            child: Text('CONFIRMAR PEDIDO'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contenido de PedidoDetalle.dart'),
            SizedBox(height: 20),
            Text('Elementos del Carrito:'),
            for (var producto in widget.carrito)
              ListTile(
                title: Text(
                    '${producto['nombre']} (Cantidad: ${producto['cantidad']})'),
                subtitle: Text('Precio: \$${producto['precio_venta']}'),
                trailing: IconButton(
                  icon: Icon(Icons.remove_shopping_cart),
                  onPressed: () {
                    _eliminarDelCarrito(producto['id'].toString());
                  },
                ),
              ),
            DataTable(
              columns: [
                DataColumn(label: Text('cantidad')),
                DataColumn(label: Text('precio_unitario')),
                DataColumn(label: Text('producto')),
              ],
              rows: widget.carrito
                  .map(
                    (producto) => DataRow(
                      cells: [
                        DataCell(Text(producto['cantidad'].toString())),
                        DataCell(Text(producto['precio_venta'].toString())),
                        DataCell(Text(producto['id'].toString())),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _eliminarDelCarrito(String id) {
    setState(() {
      widget.carrito.removeWhere((producto) => producto['id'] == id);
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: PedidoDetalle(
      carrito: [
        {'id': 1, 'nombre': 'Producto 1', 'cantidad': 2, 'precio_venta': 10.0},
        {'id': 2, 'nombre': 'Producto 2', 'cantidad': 1, 'precio_venta': 15.0},
      ],
    ),
  ));
}
