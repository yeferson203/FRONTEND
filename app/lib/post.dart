import 'dart:convert';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  // Llama a la función createResource para realizar la solicitud POST
  createResource();
}

Future<void> createResource() async {
  final url = Uri.parse(
      'http://127.0.0.1:8000/api/v1/usuarios/'); // Cambia la URL por la de tu API
  final data = {
    "id": 1,
    "contrasena": "12345678",
    "roll_id": 1,
    "identificacion_usuario": "1004709913",
    "nombre_usuario": "STIVEN",
    "correo_electronico": "STIVENrosero15@gmail.com"
  }; // Datos a enviar en el cuerpo de la solicitud (cámbialo según tus necesidades)
  final response = await http.post(
    url,
    body: json.encode(data), // Convierte los datos a JSON
    headers: {
      'Content-Type': 'application/json'
    }, // Configura las cabeceras según tus necesidades
  );
  if (response.statusCode == 201) {
    // 201 significa que se ha creado el recurso con éxito
    final responseData = json.decode(response.body);
    print(responseData);
  } else {
    print('Error al crear el recurso: ${response.statusCode}');
  }
}
