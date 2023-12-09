import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Consumir API',
      home: UserTable(),
    );
  }
}

class UserTable extends StatefulWidget {
  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/v1/usuarios/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> fetchedUsuarios = json.decode(response.body);
        setState(() {
          usuarios = fetchedUsuarios;
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _editarUsuario(int index) async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/v1/usuarios/${usuarios[index]['id']}/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final usuarioAEditar = json.decode(response.body);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Editar Usuario'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: usuarioAEditar['contrasena'],
                      decoration: InputDecoration(labelText: 'Contraseña'),
                      onChanged: (value) {
                        usuarioAEditar['contrasena'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: usuarioAEditar['roll_id'].toString(),
                      decoration: InputDecoration(labelText: 'Roll ID'),
                      onChanged: (value) {
                        usuarioAEditar['roll_id'] = int.parse(value);
                      },
                    ),
                    TextFormField(
                      initialValue: usuarioAEditar['identificacion_usuario'],
                      decoration:
                          InputDecoration(labelText: 'Identificación Usuario'),
                      onChanged: (value) {
                        usuarioAEditar['identificacion_usuario'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: usuarioAEditar['nombre_usuario'],
                      decoration: InputDecoration(labelText: 'Nombre Usuario'),
                      onChanged: (value) {
                        usuarioAEditar['nombre_usuario'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: usuarioAEditar['correo_electronico'],
                      decoration:
                          InputDecoration(labelText: 'Correo Electrónico'),
                      onChanged: (value) {
                        usuarioAEditar['correo_electronico'] = value;
                      },
                    ),
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
                      body: json.encode(usuarioAEditar),
                      headers: {'Content-Type': 'application/json'},
                    );

                    if (response.statusCode == 200) {
                      _fetchUsuarios();
                      Navigator.of(context).pop();
                    } else {
                      print(
                          'Error al actualizar el usuario: ${response.statusCode}');
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error al obtener el usuario: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _eliminarUsuario(int index) async {
    final String apiUrl =
        'http://127.0.0.1:8000/api/v1/usuarios/${usuarios[index]['id']}/';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 204) {
        setState(() {
          usuarios.removeAt(index);
        });
        print('Usuario eliminado con éxito');
      } else {
        print('Error al eliminar el usuario: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _agregarUsuario() async {
    Map<String, dynamic> nuevoUsuario = {
      'contrasena': '',
      'roll_id': 0,
      'identificacion_usuario': '',
      'nombre_usuario': '',
      'correo_electronico': '',
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  onChanged: (value) {
                    nuevoUsuario['contrasena'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Roll ID'),
                  onChanged: (value) {
                    nuevoUsuario['roll_id'] = int.parse(value);
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Identificación Usuario'),
                  onChanged: (value) {
                    nuevoUsuario['identificacion_usuario'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre Usuario'),
                  onChanged: (value) {
                    nuevoUsuario['nombre_usuario'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Correo Electrónico'),
                  onChanged: (value) {
                    nuevoUsuario['correo_electronico'] = value;
                  },
                ),
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
                final response = await http.post(
                  Uri.parse('http://127.0.0.1:8000/api/v1/usuarios/'),
                  body: json.encode(nuevoUsuario),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 201) {
                  _fetchUsuarios();
                  Navigator.of(context).pop();
                } else {
                  print('Error al agregar el usuario: ${response.statusCode}');
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _agregarUsuario();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: usuarios.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tabla de Usuarios:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Contraseña')),
                          DataColumn(label: Text('Roll ID')),
                          DataColumn(label: Text('Identificación Usuario')),
                          DataColumn(label: Text('Nombre Usuario')),
                          DataColumn(label: Text('Correo Electrónico')),
                          DataColumn(label: Text('Acciones')),
                        ],
                        rows: usuarios
                            .asMap()
                            .entries
                            .map(
                              (entry) => DataRow(
                                cells: [
                                  DataCell(Text('${entry.value['id']}')),
                                  DataCell(
                                      Text('${entry.value['contrasena']}')),
                                  DataCell(Text('${entry.value['roll_id']}')),
                                  DataCell(Text(
                                      '${entry.value['identificacion_usuario']}')),
                                  DataCell(
                                      Text('${entry.value['nombre_usuario']}')),
                                  DataCell(Text(
                                      '${entry.value['correo_electronico']}')),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            _editarUsuario(entry.key);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            _eliminarUsuario(entry.key);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
