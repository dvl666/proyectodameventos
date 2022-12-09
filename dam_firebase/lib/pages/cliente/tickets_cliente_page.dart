import 'package:dam_firebase/pages/cliente/detalle_ticket_cliente_page.dart';
import 'package:dam_firebase/providers/detalles_provider.dart';
import 'package:dam_firebase/providers/eventos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TicketsClientesPage extends StatefulWidget {
  String usuario;
  TicketsClientesPage(this.usuario, {super.key});

  @override
  State<TicketsClientesPage> createState() => _TicketsClientesPageState();
}

class _TicketsClientesPageState extends State<TicketsClientesPage> {
  String user = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        FutureBuilder(
          future: DetallesProvider().getDetalles(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Expanded(
                child: ListView.separated(
              separatorBuilder: ((context, index) => Divider()),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var detalle = snapshot.data[index];

                if (detalle['usuario'] == widget.usuario) {
                  return Container(
                    margin: EdgeInsets.only(right: 30, left: 30),
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2)),
                    child: ListTile(
                      title: Text(
                        "Nombre: " + detalle['usuario'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Codigo de Evento: " +
                          detalle['id_evento'].toString()),
                      trailing: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: IconButton(
                          icon: Icon(
                            MdiIcons.ticket,
                            size: 50,
                            color: Colors.amber[200],
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => detalleTicketCliente(
                                      detalle['id_detalle'],
                                      detalle['usuario'],
                                      detalle['id_evento']),
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center();
                }
              },
            ));
          },
        )
      ]),
    );
  }
}
