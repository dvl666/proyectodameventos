import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //obtener los productos
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
    //int limite = 10;
    //return FirebaseFirestore.instance.collection('productos').where('stock', isLessThan: limite).snapshots();
  }

  //agregar
  Future agregar(String nombre, String descripcion, String fecha) {
    return FirebaseFirestore.instance
        .collection('eventos')
        .doc()
        .set({'nombre': nombre, 'descripcion': descripcion, 'fecha': fecha});
  }

  //borrar
  Future borrar(String id) {
    return FirebaseFirestore.instance.collection('eventos').doc(id).delete();
  }
}
