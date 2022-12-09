import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;

class UsuariosProvider {
  final apiURL = 'http://10.0.2.2:8000/api';

  Future<LinkedHashMap<String, dynamic>> agregar(
      String usuario, int tipo) async {
    var respuesta = await http.post(
      Uri.parse(apiURL + '/usuarios'),
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'usuario': usuario,
        'tipo': tipo,
      }),
    );

    return json.decode(respuesta.body);
  }

  //borrar producto

  //retorna los datos de 1 producto en particular
  Future<LinkedHashMap<String, dynamic>> getUsuario(String usuario) async {
    var respuesta = await http.get(Uri.parse(apiURL + '/usuarios/' + usuario));
    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      return LinkedHashMap();
    }
  }
}
