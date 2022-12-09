import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_firebase/pages/admin/editar_evento_page.dart';
import 'package:dam_firebase/providers/eventos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../servicios/firestore_service.dart';
import 'agregar_evento_page.dart';

import 'editar_noticia_firebase.dart';

class noticiasCompraPage extends StatefulWidget {
  noticiasCompraPage({Key? key}) : super(key: key);

  @override
  State<noticiasCompraPage> createState() => _noticiasCompraPageState();
}

class _noticiasCompraPageState extends State<noticiasCompraPage> {
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
                  //print('PRODUCTO:' + producto.data().toString());
                  return Slidable(
                    startActionPane:
                        ActionPane(motion: ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) =>
                                  EditarEventoPageReal(evento['id_evento']));
                          Navigator.push(context, route).then((value) {
                            setState(() {});
                          });
                        },
                        backgroundColor: Colors.purple,
                        icon: MdiIcons.pen,
                        label: 'Editar',
                      ),
                    ]),
                    endActionPane:
                        ActionPane(motion: ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          confirmDialog(context, evento['nombre'])
                              .then((confirma) {
                            if (confirma) {
                              EventosProvider()
                                  .borrarEvento(evento['id_evento'])
                                  .then((fueBorrado) {
                                if (fueBorrado) {
                                  snapshot.data.removeAt(index);
                                  setState(() {});
                                  mostrarSnackbar(
                                      'Evento ${evento['nombre']} borrado');
                                }
                              });
                            }
                          });
                        },
                        backgroundColor: Colors.red,
                        label: 'Borrar',
                        icon: MdiIcons.trashCan,
                      )
                    ]),
                    child: ListTile(
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
                    ),
                  );
                },
              ),
            );
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => AgregarEventoPage(),
            );
            Navigator.push(context, route).then((value) {
              setState(() {});
            });
          },
        ),
      ],
    );
  }

  void mostrarSnackbar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(mensaje),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context, String evento) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmación de borrado'),
          content: Text('¿Confirma borrar el producto $evento?'),
          actions: [
            TextButton(
              child: Text('CANCELAR'),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              child: Text('CONFIRMAR'),
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }
}
