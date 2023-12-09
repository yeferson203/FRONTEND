import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // Lista de URLs
  List<String> urls = [
    'http://127.0.0.1:8000/api/v1/categorias/',
    'http://127.0.0.1:8000/api/v1/tallas/',
    'http://127.0.0.1:8000/api/v1/productos/',
    'http://127.0.0.1:8000/api/v1/pedidosdetalles/',
    'http://127.0.0.1:8000/api/v1/usuarios/',
    'http://127.0.0.1:8000/api/v1/facturas/',
    'http://127.0.0.1:8000/api/v1/pedidos/',
    // Agrega más URLs según sea necesario
  ];

  // Itera sobre las URLs y realiza las solicitudes GET
  for (String url in urls) {
    await fetchData(url);
  }
}

// Función para realizar la solicitud GET
Future<void> fetchData(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    print('Datos obtenidos de $url: $responseData');
  } else {
    print('Error al obtener los datos de $url: ${response.statusCode}');
  }
}
