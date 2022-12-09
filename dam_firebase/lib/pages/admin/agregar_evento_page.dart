import 'package:dam_firebase/providers/eventos_provider.dart';
import 'package:flutter/material.dart';

class AgregarEventoPage extends StatefulWidget {
  const AgregarEventoPage({super.key});

  @override
  State<AgregarEventoPage> createState() => _AgregarEventoPageState();
}

class _AgregarEventoPageState extends State<AgregarEventoPage> {
  final formKey = GlobalKey<FormState>();
  List lista = ['Activo', 'Inactivo'];
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController precioCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  TextEditingController cantidadCtrl = TextEditingController();

  int estado = 0;
  DateTime selectedDate = DateTime.now();
  String fecha = "";
  String errNombre = "";
  String errPrecio = "";
  String errDescripcion = "";
  String errCantidad = "";
  String errEstado = "";
  String errFecha = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Wrap(
            children: [
              campoNombre(),
              mostrarError(errNombre),
              campoPrecio(),
              mostrarError(errPrecio),
              campoDescripcion(),
              mostrarError(errDescripcion),
              campoCantidad(),
              mostrarError(errCantidad),
              campoEstado(),
              mostrarError(errEstado),
              campoFecha(),
              mostrarError(errFecha),
              campoBoton(),
            ],
          ),
        ),
      ),
    );
  }

  Container mostrarError(String error) {
    return Container(
      width: double.infinity,
      child: Text(
        error,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  TextFormField campoNombre() {
    return TextFormField(
      controller: nombreCtrl,
      decoration: InputDecoration(
        label: Text('Nombre'),
      ),
      style: TextStyle(fontSize: 30),
    );
  }

  TextFormField campoPrecio() {
    return TextFormField(
      controller: precioCtrl,
      decoration: InputDecoration(
        label: Text('Precio'),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 30),
    );
  }

  TextFormField campoDescripcion() {
    return TextFormField(
      controller: descripcionCtrl,
      decoration: InputDecoration(
        label: Text('Descripción'),
      ),
      style: TextStyle(fontSize: 30),
    );
  }

  TextFormField campoCantidad() {
    return TextFormField(
      controller: cantidadCtrl,
      decoration: InputDecoration(
        label: Text('Cantidad de entradas a la venta'),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 30),
    );
  }

  Container campoEstado() {
    return Container(
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
            estado = 1;
          } else {
            estado = 0;
          }
          print(estado);
        }),
        hint: Text('Seleccione Estado'),
        borderRadius: BorderRadius.circular(10),
        style: TextStyle(fontSize: 30, color: Colors.black),
      ),
      margin: EdgeInsets.symmetric(vertical: 20),
    );
  }

  Row campoFecha() {
    return Row(
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
    );
  }

  Container campoBoton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
        child: Text('Agregar Evento'),
        onPressed: () async {
          //caputar datos del form
          String descripcion = descripcionCtrl.text.trim();
          String nombre = nombreCtrl.text.trim();
          int precio = int.tryParse(precioCtrl.text.trim()) ?? 0;
          int cantidad = int.tryParse(cantidadCtrl.text.trim()) ?? 0;

          //enviar por post al api
          var respuesta = await EventosProvider().agregarEvento(
              nombre, descripcion, fecha, precio, cantidad, estado);

          //manejar errores
          if (respuesta['message'] != null) {
            var errores = respuesta['errors'];
            errNombre = errores['nombre'] != null ? errores['nombre'][0] : '';
            errDescripcion =
                errores['descripcion'] != null ? errores['descripcion'][0] : '';
            errPrecio = errores['precio'] != null ? errores['precio'][0] : '';
            errCantidad = errores['cant_entradas'] != null
                ? errores['cant_entradas'][0]
                : '';
            errEstado = errores['estado'] != null ? errores['estado'][0] : '';
            errFecha = errores['fecha'] != null ? errores['fecha'][0] : '';
            setState(() {});
            return;
          }

          //redireccionar a pagina que lista productos
          Navigator.pop(context);
        },
      ),
    );
  }
}
