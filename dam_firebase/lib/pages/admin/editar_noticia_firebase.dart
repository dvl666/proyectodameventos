import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditarEventoPage extends StatefulWidget {
  String idEvento;

  EditarEventoPage(this.idEvento, {Key? key}) : super(key: key);
  @override
  State<EditarEventoPage> createState() => _EditarEventoPageState();
}

class _EditarEventoPageState extends State<EditarEventoPage> {
  final formKey = GlobalKey<FormState>();
  List lista = ['Activo', 'Inactivo'];
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController precioCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  bool estado = true;
  DateTime selectedDate = DateTime.now();
  String fecha = "";
  CollectionReference collection =
      FirebaseFirestore.instance.collection('eventos');

  @override
  Widget build(BuildContext context) {
    //nombreCtrl.text = widget.nombre;
    //precioCtrl.text = widget.precio.toString();
    //descripcionCtrl.text = widget.descripcion;
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Evento '),
      ),
      body: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese algun texto';
                    }
                    return null;
                  },
                  controller: nombreCtrl,
                  decoration: InputDecoration(
                    label: Text('Nombre'),
                  ),
                  style: TextStyle(fontSize: 30),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese algun texto';
                    }
                    return null;
                  },
                  controller: precioCtrl,
                  decoration: InputDecoration(
                    label: Text('Precio'),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 30),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese algun texto';
                    }
                    return null;
                  },
                  controller: descripcionCtrl,
                  decoration: InputDecoration(
                    label: Text('Descripción'),
                  ),
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                  child: DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor ingrese algun texto';
                      }
                      return null;
                    },
                    items: lista.map((e) {
                      return DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      );
                    }).toList(),
                    onChanged: ((value) {
                      if (value == 'Activo') {
                        estado = true;
                      } else {
                        estado = false;
                      }
                      print(estado);
                    }),
                    hint: Text('Seleccione Estado'),
                    borderRadius: BorderRadius.circular(10),
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 20),
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          final DateTime? dateTime = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2050));
                          if (dateTime != null) {
                            setState(() {
                              selectedDate = dateTime;
                              fecha =
                                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                              print(fecha);
                            });
                          }
                        },
                        child: Text('Elige la fecha del evento')),
                    Text(
                      ' ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    child: Text('Editar Evento'),
                    onPressed: () {
                      int precio = int.tryParse(precioCtrl.text.trim()) ?? 0;
                      if (formKey.currentState!.validate()) {
                        collection.doc(widget.idEvento).set({
                          'nombre': nombreCtrl.text.trim(),
                          'descripcion': descripcionCtrl.text.trim(),
                          'fecha': fecha,
                          'estado': estado,
                          'precio': precio
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
