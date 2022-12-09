import 'package:dam_firebase/pages/cliente/eventos_cliente_page.dart';
import 'package:dam_firebase/pages/cliente/noticias_cliente_page.dart';
import 'package:dam_firebase/pages/cliente/tickets_cliente_page.dart';
import 'package:dam_firebase/pages/login_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class eventosPage extends StatefulWidget {
  String usuario;
  eventosPage(this.usuario, {Key? key}) : super(key: key);

  static List<Widget> paginas = [noticiasClientePage(), eventosClientePage()];

  @override
  State<eventosPage> createState() => _eventosPageState();
}

class _eventosPageState extends State<eventosPage> {
  // This widget is the root of your application.
  int indexSel = 0;

  final bool _admin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent[400],
          title: Row(children: [
            Text("USM Eventos"),
            Spacer(),
          ]),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.account_circle),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'tickets',
                  child: Text('Ver mis entradas'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Cerrar Sesión'),
                ),
              ],
              onSelected: (opcionSeleccionada) {
                if (opcionSeleccionada == 'logout') {
                  logout(context);
                }
                if (opcionSeleccionada == 'tickets') {
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) =>
                          TicketsClientesPage(widget.usuario));
                  Navigator.push(context, route);
                }
              },
            ),
          ],
          leading: Icon(MdiIcons.book),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.purple[300],
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.newspaper,
                color: Colors.white,
              ),
              label: "Eventos",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.ticket,
                color: Colors.white,
              ),
              label: "Tickets",
            ),
          ],
          currentIndex: indexSel,
          onTap: pagSel,
        ),
        body: eventosPage.paginas[indexSel]);
  }

  void pagSel(int index) {
    setState(() {
      indexSel = index;
    });
  }
}

Future<String> getUser() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString('user') ?? '';
}

void logout(BuildContext context) async {
  //cerrar sesion en firebase
  await FirebaseAuth.instance.signOut();

  //borrar user email de shared preferences
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.remove('user');

  //redirigir al login
  MaterialPageRoute route =
      MaterialPageRoute(builder: ((context) => LoginPage()));
  Navigator.pushReplacement(context, route);
}
