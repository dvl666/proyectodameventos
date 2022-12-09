import 'package:dam_firebase/providers/eventos_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class detalleTicketCliente extends StatefulWidget {
  int id_detalle;
  String usuario;
  int id_evento;
  detalleTicketCliente(this.id_detalle, this.usuario, this.id_evento,
      {super.key});

  @override
  State<detalleTicketCliente> createState() => _detalleTicketClienteState();
}

class _detalleTicketClienteState extends State<detalleTicketCliente> {
  String nombre = "", descripcion = "", fecha = "";
  int cantidad = 0, precio = 0, estado = 0;
  final fPrecio =
      NumberFormat.currency(decimalDigits: 0, locale: 'es-CL', symbol: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Detalle Ticket"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: EventosProvider().getEvento(widget.id_evento),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var evento = snapshot.data;
              nombre = evento['nombre'];
              descripcion = evento['descripcion'];
              fecha = evento['fecha'];
              cantidad = evento['cant_entradas'];
              precio = evento['precio'];
              estado = evento['estado'];
              return Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: QrImage(
                        data: "http://www.usmentradas.cl/" +
                            widget.id_detalle.toString(),
                        size: 250,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(width: 6),
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                  Container(
                    color: Colors.amber.withOpacity(0.2),
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Container(
                          child: Text(fecha),
                        ),
                        Container(
                          child: Text(
                            widget.usuario.toString(),
                            style: TextStyle(
                                fontSize: 31, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            nombre,
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[900]),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 35),
                        ),
                        Container(
                          child: Text(descripcion),
                        ),
                        Container(
                          child: Text(
                            "\$" + fPrecio.format(precio) + " CLP",
                            style: TextStyle(fontSize: 30),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
