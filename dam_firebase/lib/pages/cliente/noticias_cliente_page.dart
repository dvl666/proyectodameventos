import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../servicios/firestore_service.dart';
import '../admin/editar_noticia_firebase.dart';

class noticiasClientePage extends StatefulWidget {
  const noticiasClientePage({super.key});

  @override
  State<noticiasClientePage> createState() => _noticiasClientePageState();
}

class _noticiasClientePageState extends State<noticiasClientePage> {
  @override
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
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    width: 350,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 2),
                    ),
                    child: ListTile(
                      leading: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Icon(
                          MdiIcons.newspaper,
                          color: Colors.deepPurple,
                          size: 60,
                        ),
                      ),
                      title: Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            evento['nombre'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10, top: 10),
                            height: 70,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                margin: EdgeInsets.only(right: 30, left: 20),
                                child: Text(
                                  evento['descripcion'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            evento['fecha'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue[500]),
                          )
                        ],
                      ),
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
}
