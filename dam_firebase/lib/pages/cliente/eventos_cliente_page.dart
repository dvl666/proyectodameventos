import 'package:dam_firebase/pages/cliente/detalle_evento_cliente_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/eventos_provider.dart';

class eventosClientePage extends StatefulWidget {
  eventosClientePage({super.key});

  @override
  State<eventosClientePage> createState() => _eventosClientePageState();
}

class _eventosClientePageState extends State<eventosClientePage> {
  final fPrecio =
      NumberFormat.currency(decimalDigits: 0, locale: 'es-CL', symbol: '');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: EventosProvider().getEventos(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var evento = snapshot.data[index];
                  int estado = evento['estado'];
                  //print('PRODUCTO:' + producto.data().toString());
                  return ListTile(
                    leading: Icon(
                      MdiIcons.ticket,
                      color: Colors.deepPurple,
                      size: 60,
                    ),
                    title: Text(
                      evento['nombre'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      evento['descripcion'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        MdiIcons.cart,
                        size: 40,
                        color: Color(
                            estadoColor(estado)), //colocar variable estado
                      ),
                      onPressed: () {
                        setState(() {
                          if (evento['estado'] == 0) {
                            print("no se puede comprar");
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    detalleEventoPage(evento['id_evento']),
                              ),
                            );
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  int estadoColor(int estado) {
    if (estado == 1) {
      return 0xFF00a9e5;
    } else {
      return 0xFFd54745;
    }
  }
}
