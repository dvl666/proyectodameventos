import 'package:dam_firebase/providers/detalles_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/eventos_provider.dart';

class detalleEventoPage extends StatefulWidget {
  int id_evento;
  detalleEventoPage(this.id_evento, {Key? key}) : super(key: key);

  @override
  State<detalleEventoPage> createState() => _detalleEventoPageState();
}

class _detalleEventoPageState extends State<detalleEventoPage> {
  final fPrecio =
      NumberFormat.currency(decimalDigits: 0, locale: 'es-CL', symbol: '');
  int cont = 1;
  String usuario1 = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: Container(
            child: Row(
              children: [
                Container(
                  child: Icon(MdiIcons.newspaper),
                  margin: EdgeInsets.only(right: 10),
                ),
                Text("Evento"),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: this.getUser2(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Cargando...');
                }
                usuario1 = snapshot.data;
                return Text('');
              },
            ),
            FutureBuilder(
              future: EventosProvider().getEvento(widget.id_evento),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var evento = snapshot.data;
                return Container(
                  child: Column(
                    children: [
                      Icon(
                        MdiIcons.ticketConfirmation,
                        size: 250,
                        color: Colors.green[800],
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          evento['fecha'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          evento['nombre'],
                          style: TextStyle(fontSize: 30),
                        ),
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      Container(
                        child: Text(
                          evento['descripcion'],
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Divider(),
                      Container(
                          child: Text(
                        "\$ " + fPrecio.format(evento['precio']) + "CLP",
                        style: TextStyle(fontSize: 50),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent[400]),
                          child: Column(
                            children: [
                              Container(
                                child: Text("COMPRAR"),
                              ),
                              Icon(MdiIcons.cart)
                            ],
                          ),
                          onPressed: () async {
                            if (cont == 1) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _popUp(context),
                              );
                              await DetallesProvider().agregarDetalle(
                                  usuario1, evento['id_evento']);
                              cont = cont - 1;
                            } else {
                              print("No se puede comprar mas entradas");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ));
  }

  Widget _popUp(BuildContext context) {
    return new AlertDialog(
      title: Row(
        children: [
          Container(
            child: Icon(MdiIcons.cart),
            margin: EdgeInsets.only(right: 25),
          ),
          Text('Comprar Ticket')
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 40),
            child: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Center(
                child: Icon(
                  MdiIcons.checkCircle,
                  color: Colors.green[600],
                  size: 70,
                ),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 102),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Text(
                'Cerrar',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<String> getUser2() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user') ?? '';
  }
}
