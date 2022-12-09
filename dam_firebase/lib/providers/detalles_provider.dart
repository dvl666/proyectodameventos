import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;

class DetallesProvider {
  final apiURL = 'http://10.0.2.2:8000/api';

  Future<LinkedHashMap<String, dynamic>> agregarDetalle(
    String usuario,
    int id_evento,
  ) async {
    var respuesta = await http.post(
      Uri.parse(apiURL + '/detalles'),
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'usuario': usuario,
        'id_evento': id_evento,
      }),
    );

    return json.decode(respuesta.body);
  }

  Future<List<dynamic>> getDetalles() async {
    var respuesta = await http.get(Uri.parse(apiURL + '/detalles'));

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      return [];
    }
  }
}
