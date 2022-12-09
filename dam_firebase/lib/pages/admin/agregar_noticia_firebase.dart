import 'package:flutter/material.dart';

import '../../servicios/firestore_service.dart';

class AgregarNoticiaFirebase extends StatefulWidget {
  const AgregarNoticiaFirebase({super.key});

  @override
  State<AgregarNoticiaFirebase> createState() => _AgregarNoticiaFirebaseState();
}

class _AgregarNoticiaFirebaseState extends State<AgregarNoticiaFirebase> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String fecha = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Wrap(children: [
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
              controller: descripcionCtrl,
              decoration: InputDecoration(
                label: Text('Descripción'),
              ),
              style: TextStyle(fontSize: 30),
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
                child: Text('Agregar Noticia'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    FirestoreService().agregar(nombreCtrl.text.trim(),
                        descripcionCtrl.text.trim(), fecha);

                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
