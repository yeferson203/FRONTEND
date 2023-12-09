import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/login.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'pedidodetalle.dart';
import 'Editarusuario.dart';

class Usuario {
  final String nombre;

  Usuario({required this.nombre});
}

class TiendaStock extends StatefulWidget {
  @override
  _TiendaStockState createState() => _TiendaStockState();
}

class _TiendaStockState extends State<TiendaStock> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> productos = [];
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> tallas = [];
  List<Map<String, dynamic>> resultados = [];
  List<Map<String, dynamic>> carrito = [];
  late String nombreUsuario;

  final ItemScrollController itemScrollController = ItemScrollController();
  String infoProductoAgregado = "";

  @override
  void initState() {
    super.initState();
    nombreUsuario = Login.getUsuarioActual();
    fetchData("http://127.0.0.1:8000/api/v1/productos/");
    fetchData("http://127.0.0.1:8000/api/v1/categorias/");
    fetchData("http://127.0.0.1:8000/api/v1/tallas/");
  }

  Future<void> fetchData(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (url.contains("productos")) {
          setState(() {
            productos = List<Map<String, dynamic>>.from(data);
          });
        } else if (url.contains("categorias")) {
          setState(() {
            categorias = List<Map<String, dynamic>>.from(data);
          });
        } else if (url.contains("tallas")) {
          setState(() {
            tallas = List<Map<String, dynamic>>.from(data);
          });
        }
      } else {
        print(
            'Error al hacer la solicitud, código de estado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error al hacer la solicitud a la API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Nombre de usuario: $nombreUsuario');

    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda de Motos - Stock'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Usuario: $nombreUsuario'),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    setState(() {
                      _mostrarCarrito();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    setState(() {
                      _mostrarInformacionUsuario();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    _cerrarSesion();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.admin_panel_settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuAdmin()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/image$index.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 150.0,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar productos...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        String query = _searchController.text.toLowerCase();
                        setState(() {
                          resultados = productos
                              .where((producto) =>
                                  producto['nombre']
                                      .toLowerCase()
                                      .contains(query) ||
                                  producto['descripcion']
                                      .toLowerCase()
                                      .contains(query))
                              .toList();
                        });
                      },
                      child: Text('Buscar'),
                    ),
                  ],
                ),
              ),
              resultados.isEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        return _buildStockItem(
                          productos[index]['id'].toString(),
                          productos[index]['nombre'],
                          productos[index]['descripcion'],
                          productos[index]['precio_venta'],
                          productos[index]['imagen'],
                          productos[index]['categoria'],
                          productos[index]['talla'],
                        );
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: resultados.length,
                      itemBuilder: (context, index) {
                        return _buildStockItem(
                          resultados[index]['id'].toString(),
                          resultados[index]['nombre'],
                          resultados[index]['descripcion'],
                          resultados[index]['precio_venta'],
                          resultados[index]['imagen'],
                          resultados[index]['categoria'],
                          resultados[index]['talla'],
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarAlCarrito(String id, String nombre, String precioVenta) {
    setState(() {
      var productoEnCarrito = carrito.firstWhere(
        (item) => item['id'] == id,
        orElse: () => {
          'id': id,
          'nombre': nombre,
          'precio_venta': precioVenta,
          'cantidad': 0
        },
      );

      if (productoEnCarrito['cantidad'] > 0) {
        productoEnCarrito['cantidad'] += 1;
      } else {
        carrito.add({
          'id': id,
          'nombre': nombre,
          'precio_venta': precioVenta,
          'cantidad': 1
        });
      }

      print(
          'Producto agregado al carrito - cantidad: ${productoEnCarrito['cantidad']}, precio_unitario: $precioVenta, producto: $id');
    });
  }

  void _mostrarCarrito() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Carrito de Compras'),
          content: Column(
            children: [
              for (var producto in carrito)
                ListTile(
                  title: Text(
                      '${producto['nombre']} (Cantidad: ${producto['cantidad']})'),
                  subtitle: Text('Precio: \$${producto['precio_venta']}'),
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PedidoDetalle(carrito: carrito),
                    ),
                  );
                },
                child: Text('Realizar Pedido'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarInformacionUsuario() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información del Usuario'),
          content: Column(
            children: [
              Text('Nombre de usuario: $nombreUsuario'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _abrirVistaEditarUsuario();
              },
              child: Text('Editar Información'),
            ),
          ],
        );
      },
    );
  }

  void _abrirVistaEditarUsuario() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarUsuario(nombreUsuario: nombreUsuario),
      ),
    );
  }

  void _cerrarSesion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  String getNombreCategoria(int idCategoria) {
    var categoria = categorias.firstWhere(
        (element) => element['id'] == idCategoria,
        orElse: () => {'descripcion': ''});
    return categoria['descripcion'];
  }

  String getNombreTalla(int idTalla) {
    var talla = tallas.firstWhere((element) => element['id'] == idTalla,
        orElse: () => {'descripcion': ''});
    return talla['descripcion'];
  }

  Widget _buildStockItem(String id, String nombre, String descripcion,
      String precioVenta, String imagen, int idCategoria, int idTalla) {
    int cantidadEnCarrito = carrito
        .where((producto) => producto['id'] == id)
        .map<int>((producto) => producto['cantidad'] as int? ?? 0)
        .fold(0, (sum, cantidad) => sum + cantidad);

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(nombre),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    _agregarAlCarrito(id, nombre, precioVenta);
                  },
                ),
                Text('$cantidadEnCarrito'),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(descripcion),
            Text('Precio: \$$precioVenta'),
            Text('Categoría: ${getNombreCategoria(idCategoria)}'),
            Text('Talla: ${getNombreTalla(idTalla)}'),
          ],
        ),
        leading: Image.network(imagen),
      ),
    );
  }
}

class MenuAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú de Administrador'),
      ),
      body: Center(
        child: Text('Contenido del menú de administrador'),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: TiendaStock(),
    ),
  );
}
