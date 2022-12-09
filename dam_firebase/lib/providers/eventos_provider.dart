import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;

class EventosProvider {
  final apiURL = 'http://10.0.2.2:8000/api';

  Future<LinkedHashMap<String, dynamic>> agregarEvento(
      String nombre,
      String descripcion,
      String fecha,
      int precio,
      int cant_entradas,
      int estado) async {
    var respuesta = await http.post(
      Uri.parse(apiURL + '/eventos'),
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': nombre,
        'descripcion': descripcion,
        'fecha': fecha,
        'precio': precio,
        'cant_entradas': cant_entradas,
        'estado': estado
      }),
    );

    return json.decode(respuesta.body);
  }

  //borrar producto

  //retorna los datos de 1 producto en particular
  Future<LinkedHashMap<String, dynamic>> getEvento(int id_evento) async {
    var respuesta =
        await http.get(Uri.parse(apiURL + '/eventos/' + id_evento.toString()));
    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      return LinkedHashMap();
    }
  }

  Future<bool> borrarEvento(int id_evento) async {
    var respuesta = await http
        .delete(Uri.parse(apiURL + '/eventos/' + id_evento.toString()));
    return respuesta.statusCode == 200;

    // if (respuesta.statusCode == 200) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Future<LinkedHashMap<String, dynamic>> editarEvento(
      int id_evento,
      String nombre,
      String descripcion,
      String fecha,
      int precio,
      int cant_entradas,
      int estado) async {
    var respuesta = await http.put(
      Uri.parse(apiURL + '/eventos/' + id_evento.toString()),
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        //'id_evento': id_evento,
        'nombre': nombre,
        'descripcion': descripcion,
        'fecha': fecha,
        'precio': precio,
        'cant_entradas': cant_entradas,
        'estado': estado
      }),
    );

    return json.decode(respuesta.body);
  }

  Future<List<dynamic>> getEventos() async {
    var respuesta = await http.get(Uri.parse(apiURL + '/eventos'));

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      return [];
    }
  }
}
