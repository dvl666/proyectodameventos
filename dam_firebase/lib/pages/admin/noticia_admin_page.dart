import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_firebase/pages/admin/agregar_noticia_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../servicios/firestore_service.dart';

import 'editar_noticia_firebase.dart';

class noticiaAdminPage extends StatefulWidget {
  const noticiaAdminPage({Key? key}) : super(key: key);

  @override
  State<noticiaAdminPage> createState() => _noticiaAdminPageState();
}

class _noticiaAdminPageState extends State<noticiaAdminPage> {
  final fPrecio =
      NumberFormat.currency(decimalDigits: 0, locale: 'es-CL', symbol: '');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: FirestoreService().eventos(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var evento = snapshot.data!.docs[index];
                  //print('PRODUCTO:' + producto.data().toString());
                  return Slidable(
                    startActionPane:
                        ActionPane(motion: ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) =>
                                  EditarEventoPage(evento.id));
                          Navigator.push(context, route);
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
                          FirestoreService().borrar(evento.id);
                        },
                        backgroundColor: Colors.red,
                        label: 'Borrar',
                        icon: MdiIcons.trashCan,
                      )
                    ]),
                    child: ListTile(
                      leading: Icon(
                        MdiIcons.newspaper,
                        color: Colors.deepPurple,
                        size: 60,
                      ),
                      title: Text(
                        evento['nombre'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                      subtitle: Text(
                        evento['descripcion'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Icon(
                        MdiIcons.lightbulb,
                        size: 45,
                        color: Colors.green,
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
              builder: (context) => AgregarNoticiaFirebase(),
            );
            Navigator.push(context, route).then((value) {
              setState(() {});
            });
          },
        ),
      ],
    );
  }
}
