import 'dart:convert';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  // Llama a la función createResource para realizar la solicitud POST
  int id = 5;
  updateResource(id);
}

Future<void> updateResource(int resourceId) async {
  final url = Uri.parse(
      'http://localhost:8000/api/v1/usuarios/$resourceId/'); // URL con el ID delrecurso a actualizar
  final data = {
    "id": 1,
    "contrasena": "12345678",
    "roll_id": 1,
    "identificacion_usuario": "1004709913",
    "nombre_usuario": "STIVEN",
    "correo_electronico": "STIVENrosero15@gmail.com"
  }; // Nuevos datos (cámbialo según tus necesidades)
  final response = await http.put(
    url,
    body: json.encode(data),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    // 200 significa que la actualización se realizó con éxito
    final responseData = json.decode(response.body);
    print(responseData);
  } else {
    print('Error al actualizar el recurso: ${response.statusCode}');
  }
}
